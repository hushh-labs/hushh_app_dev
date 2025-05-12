import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/insurance_receipt.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_insurance_details_section.dart';

class UserCardWalletInfoInsurancePolicyDetailsComponent
    extends StatelessWidget {
  final InsuranceReceipt? receipt;
  final bool fromHome;

  const UserCardWalletInfoInsurancePolicyDetailsComponent(
      {super.key, this.receipt, this.fromHome = false});

  @override
  Widget build(BuildContext context) {
    return DetailSection(
      title: 'POLICY DETAILS',
      onTap: () {},
      children: [
        if((receipt?.logo != null) && fromHome)
        Image.network(receipt!.logo!),
        DetailItem(
            label: 'INSURERS NAME',
            value: receipt?.policyDetails.policyholderName),
        DetailItem(
            label: 'POLICY NUMBER', value: receipt?.policyDetails.policyNumber),
        DetailItem(
            label: 'START DATE',
            value: receipt?.policyDetails.insuranceStartDate),
        DetailItem(
            label: 'END DATE', value: receipt?.policyDetails.insuranceEndDate),
        DetailItem(
            label: 'PREMIUM AMOUNT',
            value: receipt?.policyDetails.premiumAmount),
        DetailItem(
            label: 'PAYMENT FREQUENCY',
            value: receipt?.policyDetails.paymentFrequency),
      ],
    );
  }
}
