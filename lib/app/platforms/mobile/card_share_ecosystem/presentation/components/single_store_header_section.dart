import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_purchase_requirements_prompt_bottom_sheet.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class SingleStoreHeaderSection extends StatelessWidget {
  final NearbyFoundBrandOffers brandOffer;

  const SingleStoreHeaderSection({super.key, required this.brandOffer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    brandOffer.logoPath,
                  )
              )
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brandOffer.address,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    print(sl<CardWalletPageBloc>()
                        .allCards);
                    showModalBottomSheet(
                        isDismissible: true,
                        enableDrag: true,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) =>
                            UserPurchaseRequirementsPromptBottomSheet(
                                brandId: brandOffer.brandId,
                                cardId: sl<CardWalletPageBloc>()
                                    .allCards
                                    .firstWhereOrNull((element) =>
                                        element.item2.brandId ==
                                        brandOffer.brandId)
                                    ?.item2
                                    .id));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Need Something?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
