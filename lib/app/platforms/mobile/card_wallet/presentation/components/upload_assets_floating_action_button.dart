import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/user_card_wallet_info_screen.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class UploadAssetsFloatingActionButton extends StatelessWidget {
  final CardModel cardData;

  const UploadAssetsFloatingActionButton({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    final controller = sl<SharedAssetsReceiptsBloc>();
    return CustomFloatingActionButton(
      primary: cardData.primary,
      tabs: const ['Take a Picture', 'Upload Image', 'Upload Docs'],
      onTap: (index) {
        switch (index) {
          case 0:
            controller.add(ShareImagesVideosEvent(
                context, cardData,
                pop: false, fromCamera: true));
            break;
          case 1:
            controller.add(ShareImagesVideosEvent(
                context, cardData,
                pop: false));
            break;
          case 2:
            controller
                .add(ShareDocumentsEvent(context, cardData.brandName));
            break;
        }
      },
    );
  }
}
