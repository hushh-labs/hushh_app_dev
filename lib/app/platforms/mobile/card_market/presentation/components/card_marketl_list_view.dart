import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_market_list_tile.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';

class CardMarketListView extends StatelessWidget {
  final List<CardModel> cards;
  final bool canScroll;

  const CardMarketListView(
      {super.key, required this.cards, this.canScroll = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 4),
      physics: canScroll ? null : const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      itemBuilder: (BuildContext context, int index) {
        return CardMarketListTile(card: cards[index]);
      },
    );
  }
}
