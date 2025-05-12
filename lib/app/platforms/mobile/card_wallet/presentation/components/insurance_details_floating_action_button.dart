import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/insurance_receipt.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/user_card_wallet_info_screen.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class InsuranceDetailsFloatingActionButton extends StatelessWidget {
  final CardModel cardData;
  final List<InsuranceReceipt> receipts;

  const InsuranceDetailsFloatingActionButton(
      {super.key, required this.cardData, required this.receipts});

  @override
  Widget build(BuildContext context) {
    final uniqueInsuranceTypes =
        receipts.map((receipt) => receipt.insuranceType.name).toSet().toList();
    return CustomFloatingActionButton(
      primary: cardData.primary,
      tabs: uniqueInsuranceTypes,
      onTap: (index) {
        int receiptIndex = receipts.indexWhere((element) =>
            element.insuranceType.name == uniqueInsuranceTypes[index]);
        if (receiptIndex != -1) {
          sl<CardWalletPageBloc>().insurancePageController.animateToPage(
              receiptIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        }
      },
    );
  }
}
