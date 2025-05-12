import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class UserCardWalletInfoManageSection extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoManageSection({super.key, required this.cardData});

  @override
  State<UserCardWalletInfoManageSection> createState() =>
      _UserCardWalletInfoManageSectionState();
}

class _UserCardWalletInfoManageSectionState
    extends State<UserCardWalletInfoManageSection> {
  final controller = sl<SharedAssetsReceiptsBloc>();

  List<SharedAsset>? get assets => controller.fileDataAssets;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0 + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Image.asset(
              'assets/manage_placeholder.png',
              width: 46.w,
            ),
            const SizedBox(height: 16),
            const Text(
              'Share your card with sellers , friends or Brands and manage who has access on which data in a single place',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF939393)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: HushhLinearGradientButton(
                text: 'Share Card',
                onTap: () async {
                  controller.add(ShareCardImageEvent(widget.cardData, context));
                },
                height: 46,
                radius: 5,
              ),
            ),
            SizedBox(height: 10.h)
          ],
        ),
      ),
    );
  }
}
