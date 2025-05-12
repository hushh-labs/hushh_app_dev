import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_app_bar.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/ai_handler/prompt_gen.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/color_utils.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart' as tf;

class ReceiptItems extends StatefulWidget {
  const ReceiptItems({super.key});

  @override
  State<ReceiptItems> createState() => _ReceiptItemsState();
}

class _ReceiptItemsState extends State<ReceiptItems> {
  List<ReceiptModel> receipts = [];

  @override
  void initState() {
    final r = sl<ReceiptRadarBloc>().receipts ?? [];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final brand =
          (ModalRoute.of(context)!.settings.arguments as ReceiptModel).company;
      receipts.addAll(r
          .where((element) => element.company?.toLowerCase() == brand)
          .toList());
      final filterReceipts = receipts
          .where((element) =>
              sl<ReceiptRadarBloc>().filterBasedReceipts?.contains(element) ??
              false)
          .toList();
      if (filterReceipts.isNotEmpty) {
        receipts = filterReceipts;
      }
      receipts.sort((a, b) => sl<ReceiptRadarBloc>().sortReceipts(a, b));
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final receipt =
        (ModalRoute.of(context)!.settings.arguments as ReceiptModel);
    final brand = receipt.company;
    return Scaffold(
      // floatingActionButton: InkWell(
      //   onTap: () async {
      //     final receipts = sl<ReceiptRadarBloc>().receipts ?? [];
      //     Navigator.pushNamed(context, AppRoutes.chat.ai,
      //         arguments: PromptGen.receiptsConversationPrompt(receipts
      //             .where((element) => element.company.toLowerCase() == brand)
      //             .toList()));
      //   },
      //   child: CircleAvatar(
      //     radius: 24,
      //     backgroundColor: Colors.transparent,
      //     child: ClipOval(
      //       child: SizedBox.fromSize(
      //         size: const Size.fromRadius(24),
      //         child: Image.asset(
      //           "assets/hbot.png",
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      appBar: ReceiptRadarBrandAppBar(
        title: receipt.brand == null
            ? receipt.company?.capitalize()
            : "${receipt.brand!.capitalize()} (${receipt.company})",
        brand: brand,
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20, bottom: 12),
              child: Text(
                "Receipts (${receipts.length})",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            ListView.builder(
              itemCount: receipts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ReceiptListTile(receipt: receipts[index]);
              },
            )
          ],
        ),
      ),
    );
  }
}

class ReceiptListTile extends StatelessWidget {
  final ReceiptModel receipt;
  final EdgeInsets? padding;

  const ReceiptListTile({super.key, required this.receipt, this.padding});

  @override
  Widget build(BuildContext context) {
    final String brandName = (((receipt.brand?.trim().isNotEmpty ?? false)
            ? receipt.brand
            : receipt.company))
        ?.capitalize() ?? 'N/A';
    viewAttachment() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(16),
                child: const CupertinoActivityIndicator(),
                // You can customize the dialog further if needed
              ),
            ],
          );
        },
      );
      if (receipt.attachmentId == null) {
        final response = await Supabase.instance.client
            .from(DbTables.receiptRadarTable)
            .select('body')
            .eq('message_id', receipt.messageId!);
        Navigator.pop(context);
        if (response.isNotEmpty) {
          String? body = response.first['body'];
          Navigator.pushNamed(context, AppRoutes.shared.webViewer,
              arguments: body);
        }
        return;
      } else {
        final url = Supabase.instance.client.storage
            .from('receipt_radar')
            .getPublicUrl(
                '${receipt.messageId}_${receipt.attachmentId}.${receipt.attachmentExtension}');
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.shared.pdfNetworkViewer,
            arguments: url);
      }
      // final bytes = receipt.bytes;
      // if (bytes == null) {
      //   Navigator.pushNamed(context, AppRoutes.shared.textViewer,
      //       arguments: receipt.body ?? "...");
      // } else {
      //   final directory = await getTemporaryDirectory();
      //   final path =
      //       "${directory.path}/${DateTime.now().millisecondsSinceEpoch}.${receipt.name.split('.').last}";
      //   final file = File(path);
      //   await file.writeAsBytes(bytes);
      //   Navigator.pushNamed(context, AppRoutes.shared.pdfViewer,
      //       arguments: file.path);
      // }
    }

    final color = ColorUtils.stringToColor(brandName);
    return FocusedMenuHolder(
      menuWidth: 50.w,
      openWithTap: false,
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
            title: Text('View ${receipt.attachmentExtension}'),
            trailingIcon: const Icon(Icons.open_in_new),
            onPressed: () async {
              viewAttachment();
            }),
        FocusedMenuItem(
            backgroundColor: Colors.red,
            title: const Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
            trailingIcon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              ToastManager(Toast(
                      title: 'This feature is in development',
                      type: tf.ToastificationType.success))
                  .show(context);
            }),
      ],
      onPressed: () {
        viewAttachment();
      },
      child: ListTile(
        contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 18),
        subtitle: receipt.finalDate.year == 1800
            ? const Text('N/A')
            : Text(DateFormat("dd MMM yyyy").format(receipt.finalDate)),
        title: Text(receipt.finalTitle),
        trailing: Text(
          "${receipt.currencyObj.shorten()} ${receipt.finalCost}",
          // "${sl<HomePageBloc>().currency.shorten()} ${sl<HomePageBloc>().currency == Currency.inr ? receipt.inrTotalCost : sl<HomePageBloc>().currency == Currency.usd ? receipt.usdTotalCost : ""}",
          style: const TextStyle(fontSize: 16),
        ),
        leading: CircleAvatar(
          backgroundColor: receipt.logo?.isEmpty ?? true ? color : null,
          backgroundImage: receipt.logo?.isEmpty ?? true
              ? null
              : CachedNetworkImageProvider(receipt.logo!),
          child: receipt.logo?.isEmpty ?? true
              ? Text(
                  brandName.isEmpty ? "." : brandName[0].toUpperCase(),
                  style: TextStyle(
                    color:
                        ColorUtils.isDark(color) ? Colors.white : Colors.black,
                  ),
                )
              : null,
          // imageUrl:
          //     'https://www.adaptivewfs.com/wp-content/uploads/2020/07/logo-placeholder-image-300x300.png',
        ),
        shape: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFEBEBF7))),
      ),
    );
  }
}
