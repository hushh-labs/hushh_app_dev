import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/add_cards_bottomsheet.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class AddCardWidget extends StatelessWidget {
  final CardType cardType;
  final CardModel cardData;

  const AddCardWidget({
    super.key,
    required this.cardType,
    required this.cardData,
  });

  String get title {
    switch (cardType) {
      case CardType.brandCard:
        return "Brand Cards";
      case CardType.preferenceCard:
        return "General Cards";
    }
  }

  String get desc {
    switch (cardType) {
      case CardType.brandCard:
        return "Link brand cards for enhanced service and rewards from agents and brands.";
      case CardType.preferenceCard:
        return "Connect general cards like coffee and travel for personalized service and rewards.";
    }
  }

  bool get isBrandCard => cardType == CardType.brandCard;

  @override
  Widget build(BuildContext context) {
    List<String> selectedBrandCardIds = ((isBrandCard
            ? cardData.attachedCardIds
            : cardData.attachedPrefCardIds)) ??
        [];
    List<CardModel> brands = isBrandCard
        ? sl<CardWalletPageBloc>().brandCardList
        : sl<CardWalletPageBloc>().preferenceCards;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.black),
          ),
          Text(desc),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              showModalBottomSheet(
                isDismissible: true,
                enableDrag: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) {
                  return AddCardsBottomSheet(
                      openedCard: cardData,
                      isBrandCard: isBrandCard,
                      brands: brands,
                      selectedBrandCardIds: selectedBrandCardIds);
                },
              ).then((value) {
                List<CardModel>? selectedCards = value as List<CardModel>?;
                if (selectedCards != null) {
                  sl<AgentCardWalletPageBloc>().add(OnAttachingCardsEvent(
                    selectedCards,
                    isBrandCard,
                    cardData,
                    context,
                  ));
                }
              });
            },
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                // border: Border.all(color: const Color(0xFF737373)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: BlocBuilder(
                  bloc: sl<AgentCardWalletPageBloc>(),
                  builder: (context, state) {
                    selectedBrandCardIds = ((isBrandCard
                            ? cardData.attachedCardIds
                            : cardData.attachedPrefCardIds)) ??
                        [];

                    brands = List.from(isBrandCard
                        ? sl<CardWalletPageBloc>().brandCardList
                        : sl<CardWalletPageBloc>().preferenceCards);

                    List<CardModel> selectedBrands = [];

                    brands.removeWhere((element) => element.cid == cardData.cid);
                    selectedBrands = brands
                        .where((element) => selectedBrandCardIds
                            .contains(element.cid.toString()))
                        .toList();
                    selectedBrands = selectedBrands.reversed.toList();
                    int maxCount = 6;
                    return Row(
                      children: [
                        if (selectedBrands.isNotEmpty)
                          Expanded(
                            child: Stack(
                              children: [
                                ...List.generate(
                                    selectedBrands.take(maxCount).length,
                                    (index) => Row(
                                          children: [
                                            SizedBox(
                                                width:
                                                    (16 * index).toDouble()),
                                            SizedBox(
                                              height: 32,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.black45,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: CircleAvatar(
                                                    maxRadius: 16,
                                                    onBackgroundImageError: (exception, stackTrace) {},
                                                    backgroundImage:
                                                        NetworkImage(
                                                            selectedBrands[
                                                                    index]
                                                                .image, ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))..add(selectedBrands.length > maxCount &&
                              selectedBrands.length - 1 - maxCount != 0?Padding(
                                padding: EdgeInsets.only(left: (16 * maxCount).toDouble()),
                                child: CircleAvatar(
                                    maxRadius: 16,
                                    backgroundColor: Colors.black,
                                    child: Text(
                                        '+${selectedBrands.length - 1 - maxCount}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                              ):SizedBox()),
                              ],
                            ),
                          )
                        else
                          const Expanded(
                            child: Text('Pick a card'),
                          ),
                        const SizedBox(width: 12),
                        const Icon(Icons.chevron_right_sharp),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
