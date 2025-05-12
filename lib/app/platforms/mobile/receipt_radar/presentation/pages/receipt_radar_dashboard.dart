import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/receipt_radar_history.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/custom_receipts_tab_bar.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_filters/filters_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_text_field.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_items.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_utils.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/color_utils.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReceiptRadarDashboardPage extends StatefulWidget {
  const ReceiptRadarDashboardPage({super.key});

  @override
  State<ReceiptRadarDashboardPage> createState() =>
      _ReceiptRadarDashboardPageState();
}

class _ReceiptRadarDashboardPageState extends State<ReceiptRadarDashboardPage>
    with SingleTickerProviderStateMixin {
  final controller = TextEditingController();
  late TabController tabController;
  int selectedCategory = 0;

  bool get isSearch => controller.text.trim().isNotEmpty;

  @override
  void initState() {
    sl<ReceiptRadarBloc>().filterBasedReceipts = null;
    sl<ReceiptRadarUtils>().googleAuth(refresh: true).then((value) {
      log("sign in silently token: $value");
      if (value != null) {
        sl<ReceiptRadarBloc>().accessToken = value.item2;
        sl<ReceiptRadarBloc>().add(UpdateReceiptRadarHistoryEvent(
            ReceiptRadarHistory(
                accessToken: value.item2!,
                email: value.item1!,
                hushhId: AppLocalStorage.hushhId!)));
      }
    });
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      controller.clear();
      sl<ReceiptRadarBloc>().add(ResetFiltersEvent());
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(height: 16),
          CustomReceiptsTabBar(
            tabController: tabController,
            onValueChanged: (value) {
              setState(() {
                if (value != null) {
                  tabController.animateTo(value);
                }
              });
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReceiptRadarTextField(
                    controller: controller,
                    filtersPageType: tabController.index == 0
                        ? FiltersPageType.group
                        : FiltersPageType.individual,
                    onChanged: (_) {
                      if (tabController.index == 0) {
                        setState(() {});
                      } else {
                        setState(() {});
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: [
              BlocBuilder(
                  bloc: sl<ReceiptRadarBloc>(),
                  builder: (context, state) {
                    Map<dynamic, dynamic> brands =
                        sl<ReceiptRadarBloc>().getSortedBrandList();
                    return ListView.builder(
                      itemCount: brands.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final receiptId =
                            (brands.entries.elementAt(index).value as String);
                        if (sl<ReceiptRadarBloc>()
                                .filterBasedReceipts
                                ?.map((e) => e.messageId)
                                .contains(receiptId) ??
                            true) {
                          final receipt = sl<ReceiptRadarBloc>()
                              .receipts
                              ?.firstWhere(
                                  (element) => element.messageId == receiptId);
                          if (receipt == null) {
                            return const SizedBox();
                          }
                          final String brandName =
                              (((receipt.brand?.trim().isNotEmpty ?? false)
                                          ? receipt.brand
                                          : brands.entries.elementAt(index).key)
                                      as String)
                                  .capitalize();
                          if (!brandName
                              .toLowerCase()
                              .contains(controller.text.toLowerCase())) {
                            return const SizedBox();
                          }
                          return BrandListTile(
                            brandName: brandName,
                            receipt: receipt,
                            onTap: () {
                              Navigator.pushNamed(context,
                                  AppRoutes.receiptRadar.brandDashboard,
                                  arguments: receipt);
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    );
                  }),
              BlocBuilder(
                  bloc: sl<ReceiptRadarBloc>(),
                  builder: (context, state) {
                    List<ReceiptModel> newReceipts =
                        sl<ReceiptRadarBloc>().receipts ?? [];
                    final filterReceipts = newReceipts
                        .where((element) =>
                            sl<ReceiptRadarBloc>()
                                .filterBasedReceipts
                                ?.contains(element) ??
                            false)
                        .toList();
                    if (filterReceipts.isNotEmpty) {
                      newReceipts = filterReceipts;
                    }
                    List<ReceiptModel> sortedReceipts;
                    if (controller.text.isEmpty) {
                      newReceipts.sort(
                          (a, b) => sl<ReceiptRadarBloc>().sortReceipts(a, b));
                      sortedReceipts = newReceipts;
                    } else {
                      List<ExtractedResult<ReceiptModel>> results =
                          extractAllSorted<ReceiptModel>(
                        query: controller.text,
                        choices: newReceipts,
                        getter: (x) {
                          String combinedFields =
                              '${x.filename} ${x.brand}';
                          return combinedFields;
                        },
                      );
                      results.sort((a, b) => b.score.compareTo(a.score));
                      sortedReceipts = results.map((e) => e.choice).toList();
                    }
                    return ListView.builder(
                      itemCount: sortedReceipts.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return ReceiptListTile(receipt: sortedReceipts[index]);
                      },
                    );
                  }),
            ],
          ))
        ],
      ),
    );
  }
}

class BrandListTile extends StatefulWidget {
  final String brandName;
  final ReceiptModel receipt;
  final Function() onTap;

  const BrandListTile(
      {super.key,
      required this.brandName,
      required this.onTap,
      required this.receipt});

  @override
  State<BrandListTile> createState() => _BrandListTileState();
}

class _BrandListTileState extends State<BrandListTile> {
  @override
  Widget build(BuildContext context) {
    final color = ColorUtils.stringToColor(widget.brandName);
    if(widget.receipt.company != null) {
      return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18),
      subtitle: widget.receipt.finalDate.year == 1800
          ? const Text('N/A')
          : Text(DateFormat("dd MMM yyyy").format(widget.receipt.finalDate)),
      title: Text("${widget.brandName.capitalize()} (${widget.receipt.company})"
          .replaceAll('()', '')),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        size: 28,
        color: Colors.grey,
      ),
      leading: CircleAvatar(
        backgroundColor: widget.receipt.logo?.isEmpty ?? true ? color : null,
        backgroundImage: widget.receipt.logo?.isEmpty ?? true
            ? null
            : CachedNetworkImageProvider(widget.receipt.logo!),
        child: widget.receipt.logo?.isEmpty ?? true
            ? Text(
                widget.brandName.isEmpty
                    ? ""
                    : widget.brandName[0].toUpperCase(),
                style: TextStyle(
                  color: ColorUtils.isDark(color) ? Colors.white : Colors.black,
                ),
              )
            : null,
        // imageUrl:
        //     'https://www.adaptivewfs.com/wp-content/uploads/2020/07/logo-placeholder-image-300x300.png',
      ),
      shape: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEBEBF7))),
      onTap: widget.onTap,
    );
    }
    return const SizedBox();
  }
}
