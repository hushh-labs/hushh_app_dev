import 'package:cached_network_image/cached_network_image.dart';
import 'package:hushh_app/currency_converter/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_app_bar.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReceiptRadarBrandDashboard extends StatefulWidget {
  const ReceiptRadarBrandDashboard({super.key});

  @override
  State<ReceiptRadarBrandDashboard> createState() =>
      _ReceiptRadarBrandDashboardState();
}

class _ReceiptRadarBrandDashboardState
    extends State<ReceiptRadarBrandDashboard> {
  List<ReceiptModel>? receipts;

  ReceiptModel get receipt => receipts!.last;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final value = sl<ReceiptRadarBloc>().receipts ?? [];
      final receipt =
          ModalRoute.of(context)!.settings.arguments as ReceiptModel;
      receipts ??= [];
      receipts?.addAll(value
          .where((element) => element.company?.toLowerCase() == receipt.company)
          .toList());
      final filterReceipts = receipts
          ?.where((element) =>
              sl<ReceiptRadarBloc>().filterBasedReceipts?.contains(element) ??
              false)
          .toList();
      if (filterReceipts?.isNotEmpty ?? false) {
        receipts = filterReceipts;
      }

      receipts!.sort((a, b) => sl<ReceiptRadarBloc>().sortReceipts(a, b));

      setState(() {});
    });
    super.initState();
  }

  String totalAmount(List<ReceiptModel> receipts) => (receipts.fold(
      0.0,
      (previousValue, element) =>
          previousValue.toDouble() + (element.totalDocumentAiCost ?? element.finalCost  ?? 0))).toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final receipt = ModalRoute.of(context)!.settings.arguments as ReceiptModel;
    return Scaffold(
      appBar: ReceiptRadarBrandAppBar(
        title: receipt.brand == null
            ? receipt.company?.capitalize()
            : "${receipt.brand!.capitalize()} (${receipt.company})",
      ),
      body: receipts == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              children: [
                Container(
                  width: 100.w,
                  height: 23.h,
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          'https://firebasestorage.googleapis.com/v0/b/hushone-app.appspot.com/o/samplebg.jpg?alt=media&token=d7d1880d-0f3f-421d-92f5-6f0ea16ad946'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      receipt.brandCategory ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        receipt.finalBrand,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        receipt.finalDate.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff96734F),
                        ),
                      ),
                      Text(
                        receipt.finalLocation,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff96734F),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        "Brand contact",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF2E8EB),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.location_on_outlined),
                          ),
                          title: const Text(
                            "Address",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(receipt.finalLocation,
                              style: context.titleMedium
                                  ?.copyWith(color: const Color(0xFF96734F))),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        "Receipts",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.receiptRadar.receiptItems,
                            arguments: receipt),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "View receipts (${receipts?.length})",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Color(0xffB3B3B3),
                              )
                            ],
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pushNamed(context, AppRoutes.chat.ai,
                      //         arguments: PromptGen.receiptsConversationPrompt(
                      //             receipts!));
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(vertical: 15.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Flexible(
                      //           child: Text(
                      //             "Chat w/ $brandName receipts",
                      //             style: const TextStyle(
                      //               fontWeight: FontWeight.w500,
                      //               fontSize: 16,
                      //             ),
                      //           ),
                      //         ),
                      //         const Icon(
                      //           Icons.arrow_forward_ios_rounded,
                      //           color: Color(0xffB3B3B3),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Amount",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xff96734F),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              totalAmount(receipts ?? []),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                      if (receipt.paymentMethod?.isNotEmpty ?? false) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Payment method: ${receipt.paymentMethod}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(Icons.credit_card),
                          ],
                        ),
                      ],
                      const SizedBox(height: 26)
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
