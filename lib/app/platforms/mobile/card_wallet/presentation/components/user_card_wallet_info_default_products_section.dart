import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/cached_inventory_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/products_grid_view.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';

class UserCardWalletInfoDefaultProductsSection extends StatefulWidget {
  final CachedInventoryModel productResult;

  const UserCardWalletInfoDefaultProductsSection(
      {super.key, required this.productResult});

  @override
  State<UserCardWalletInfoDefaultProductsSection> createState() =>
      _UserCardWalletInfoDefaultProductsSectionState();
}

class _UserCardWalletInfoDefaultProductsSectionState
    extends State<UserCardWalletInfoDefaultProductsSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ProductsGridView(
        products: widget.productResult.products,
        fromCardView: true,
        productTileType: ProductTileType.viewProducts,
      ),
    );
  }
}
