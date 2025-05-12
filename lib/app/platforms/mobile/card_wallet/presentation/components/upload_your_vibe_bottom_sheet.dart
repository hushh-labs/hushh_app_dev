import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/list_tile_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/preference_card_list_view.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UploadYourVibeBottomSheet extends StatelessWidget {
  final CardModel cardData;
  final BuildContext context;

  const UploadYourVibeBottomSheet(
      {super.key, required this.cardData, required this.context});

  @override
  Widget build(BuildContext _) {
    final list = [
      ListTileModel('Images', 'assets/assets_icon.png'),
      ListTileModel('Documents', 'assets/other_docs_icon.png')
    ];
    sl<CardWalletPageBloc>().cardData = cardData;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      height: 35.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              'You can upload new assets here and provide any necessary information as image or a document',
              style: TextStyle(color: Color(0xFF4C4C4C)),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        ],
      ),
    );
  }

  void onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        sl<SharedAssetsReceiptsBloc>().add(ShareImagesVideosEvent(
            context, sl<CardWalletPageBloc>().cardData!));
        break;
      case 1:
        Navigator.pop(context);
        sl<SharedAssetsReceiptsBloc>().add(ShareDocumentsEvent(
            context, sl<CardWalletPageBloc>().cardData!.brandName));
        break;
    }
  }
}
