import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/card_bid_value.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/list_tile_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/manage_card_access_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/preference_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/share_earn_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/shared_assets_receipts.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageCardBottomSheet extends StatelessWidget {
  const ManageCardBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final list = [
      ListTileModel('Update minimum bid', 'assets/update_minimum_bid_icon.png'),
      ListTileModel(
          'View assets & receipts', 'assets/view_assets_receipts.png'),
      ListTileModel('Manage Card Access', 'assets/access.png')
    ];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      height: 45.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          SizedBox(
            width: 45.w,
            child: FittedBox(
              alignment: Alignment.topCenter,
              child:
                  sl<CardWalletPageBloc>().isSelectedCardPreferenceCard ?? false
                      ? PreferenceCardWidget(
                          ignore: true,
                          cardData: sl<CardWalletPageBloc>().cardData!,
                          userName: sl<CardWalletPageBloc>().user?.name ?? "",
                        )
                      : BrandCardWidget(
                          ignore: true,
                          brand: sl<CardWalletPageBloc>().cardData!,
                          isDetailsScreen: false,
                        ),
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'You can manage your cards here and update any necessary information required',
              style: TextStyle(color: Color(0xFF4C4C4C)),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  list.length,
                  (index) => GestureDetector(
                        onTap: () => onTap(context, index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration:
                              const BoxDecoration(color: Color(0xFFEEEEEE)),
                          child: Row(
                            children: [
                              Image.asset(list[index].leading, width: 26),
                              const SizedBox(width: 12),
                              Text(list[index].title)
                            ],
                          ),
                        ),
                      )),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.cardMarketPlace.cardValue,
            arguments: CardValueArgs(
                cardData: sl<CardWalletPageBloc>().cardData!, editMode: true));
        break;
      case 1:
        Navigator.pop(context);
        Navigator.pushNamed(
            context, AppRoutes.cardWallet.info.sharedAgentAssets,
            arguments: SharedAssetsReceiptsPageArgs(
                cardData: sl<CardWalletPageBloc>().cardData!,
                uid: AppLocalStorage.hushhId!));
        break;
      case 2:
        Navigator.pop(context);
        showModalBottomSheet(
          isDismissible: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (_) {
            return const ManageCardAccessBottomSheet();
          },
        );
    }
  }
}
