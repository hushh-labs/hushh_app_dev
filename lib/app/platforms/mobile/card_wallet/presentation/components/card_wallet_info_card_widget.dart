import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/hover_card.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/preference_card_list_view.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class CardWalletInfoCardWidget extends StatelessWidget {
  final CardModel cardData;

  const CardWalletInfoCardWidget({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    final controller = sl<CardWalletPageBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RepaintBoundary(
        key: controller.cardKey,
        child: cardData.isPreferenceCard
            ? Hero(
                tag: cardData.id!,
                child: SizedBox(
                  height: preferenceCardHeight,
                  child: HoverCard(builder: (context, hovering) {
                    return PreferenceCardWidget(
                      isDetailsScreen: true,
                      cardData: cardData,
                      ignore: true,
                      userName: sl<CardWalletPageBloc>().user?.name ?? "",
                    );
                  }, depthColor: Colors.transparent),
                ),
              )
            : Hero(
                tag: cardData.id!,
                child: SizedBox(
                  height: cardHeight,
                  child: HoverCard(builder: (context, hovering) {
                    return BrandCardWidget(
                      brand: cardData,
                      ignore: true,
                      isDetailsScreen: true,
                    );
                  }),
                ),
              ),
      ),
    );
  }
}
