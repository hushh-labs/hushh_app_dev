import 'package:flutter/cupertino.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_marketl_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';

import '../../../../../shared/core/local_storage/local_storage.dart';

class CardMarketBrandListView extends StatelessWidget {
  final List<CardModel> featuredCards;
  final List<CardModel> otherCards;

  const CardMarketBrandListView(
      {super.key, required this.featuredCards, required this.otherCards});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Featured",
                  style: TextStyle(color: CupertinoColors.inactiveGray),
                ),
              ),
              CardMarketListView(cards: featuredCards)
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Other cards",
                  style: TextStyle(color: CupertinoColors.inactiveGray),
                ),
              ),
              CardMarketListView(cards: otherCards)
            ],
          ),
        ],
      ),
    );
  }
}
