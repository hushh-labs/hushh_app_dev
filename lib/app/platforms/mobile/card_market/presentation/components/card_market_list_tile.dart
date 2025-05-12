import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_market_place_button.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CardMarketListTile extends StatelessWidget {
  final CardModel card;

  const CardMarketListTile({super.key, required this.card});

  bool get isAdd => card.isPreferenceCard
      ? !sl<CardWalletPageBloc>().preferenceCards.contains(card)
      : !sl<CardWalletPageBloc>().brandCardList.contains(card);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if(isAdd) {
                      Navigator.pushNamed(context,
                        AppRoutes.cardMarketPlace.shareYourPreference,
                        arguments: card);
                    } else {
                      Navigator.pushNamed(context, AppRoutes.cardWallet.info.main,
                          arguments: CardWalletInfoPageArgs(cardData: card));
                    }
                  },
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                      card.image,
                    ))),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.brandName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff141414),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        card.category,
                        style: const TextStyle(
                            color: Color(0xff858585), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CardMarketPlaceButton(card: card)
        ],
      ),
    );
  }
}
