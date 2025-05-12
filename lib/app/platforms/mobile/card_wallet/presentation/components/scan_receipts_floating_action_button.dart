import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/receipt_scan_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/user_card_wallet_info_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScanReceiptsFloatingActionButton extends StatelessWidget {
  final CardModel cardData;

  const ScanReceiptsFloatingActionButton({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      primary: cardData.primary,
      tabs: const ['Scan Receipt'],
      onTap: (index) {
        if (index == 0) {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            constraints: BoxConstraints(maxHeight: 80.h),
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            builder: (context) => const ReceiptScanBottomSheet(),
          );
        }
      },
    );
  }
}
