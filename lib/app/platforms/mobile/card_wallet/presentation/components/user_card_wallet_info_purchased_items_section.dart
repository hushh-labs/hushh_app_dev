import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/purchased_item.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class UserCardWalletInfoPurchasedItemsSection extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoPurchasedItemsSection(
      {super.key, required this.cardData});

  @override
  State<UserCardWalletInfoPurchasedItemsSection> createState() =>
      _UserCardWalletInfoPurchasedItemsSectionState();
}

class _UserCardWalletInfoPurchasedItemsSectionState
    extends State<UserCardWalletInfoPurchasedItemsSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PurchaseList(
              title: 'Items',
              purchasedItems: sl<CardWalletPageBloc>().purchasedItems ?? []),
        ],
      ),
    );
  }
}

class PurchaseList extends StatelessWidget {
  final String title;
  final List<PurchasedItem> purchasedItems;

  const PurchaseList(
      {super.key, required this.title, required this.purchasedItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: context.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () async {},
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  title: Text(
                    purchasedItems[index].subCategories.first,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Text(
                    '${sl<HomePageBloc>().currency.shorten()}${purchasedItems[index].totalAmount}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ),
            separatorBuilder: (context, index) => SizedBox(
                height: 4,
                child: Divider(
                  color: Colors.grey.shade200,
                )),
            itemCount: purchasedItems.length),
      ],
    );
  }
}
