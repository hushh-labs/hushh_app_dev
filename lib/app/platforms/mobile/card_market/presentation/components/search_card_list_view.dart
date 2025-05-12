import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_marketl_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';

class SearchCardListView extends StatelessWidget {
  final List<CardModel> searchListCards;

  const SearchCardListView({super.key, required this.searchListCards});

  @override
  Widget build(BuildContext context) {
    return searchListCards.isEmpty
        ? const Expanded(
            child: Center(
              child: Text('No cards found!'),
            ),
          )
        : Expanded(
            child: CardMarketListView(
              cards: searchListCards,
              canScroll: true,
            ),
          );
  }
}
