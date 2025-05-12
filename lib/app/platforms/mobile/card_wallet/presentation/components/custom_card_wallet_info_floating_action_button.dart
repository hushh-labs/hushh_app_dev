import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/insurance_details_floating_action_button.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/scan_receipts_floating_action_button.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/upload_assets_floating_action_button.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class CustomCardWalletInfoFloatingActionButton extends StatelessWidget {
  final CardModel cardData;

  const CustomCardWalletInfoFloatingActionButton(
      {super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    final controller = sl<CardWalletPageBloc>();
    return BlocBuilder(
      bloc: controller,
      builder: (context, state) {
        bool isOnReceiptsTabAndReceiptsAreNotEmpty =
            controller.selectedCardWalletInfoTabIndex == 1 &&
                (sl<SharedAssetsReceiptsBloc>().fileDataReceipts?.isNotEmpty ??
                    false);
        bool isOnUploadsTabAndUploadsAreNotEmpty =
            controller.selectedCardWalletInfoTabIndex == 2 &&
                (sl<SharedAssetsReceiptsBloc>().fileDataAssets?.isNotEmpty ??
                    false);
        bool isInsuranceCardAndInsuranceReceiptsAreNotEmpty =
            (controller.insuranceReceipts?.isNotEmpty ?? false) &&
                controller.selectedCardWalletInfoTabIndex == 0 &&
                cardData.id == Constants.insuranceCardId;
        return isOnReceiptsTabAndReceiptsAreNotEmpty
            ? ScanReceiptsFloatingActionButton(cardData: cardData)
            : isOnUploadsTabAndUploadsAreNotEmpty
                ? UploadAssetsFloatingActionButton(cardData: cardData)
                : isInsuranceCardAndInsuranceReceiptsAreNotEmpty
                    ? InsuranceDetailsFloatingActionButton(
                        cardData: cardData,
                        receipts: controller.insuranceReceipts!,
                      )
                    : const SizedBox();
      },
    );
  }
}
