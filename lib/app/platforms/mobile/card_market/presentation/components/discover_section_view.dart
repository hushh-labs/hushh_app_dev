import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/products_horizontal_view.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';

class DiscoverSectionView extends StatelessWidget {
  final String heading;
  final String description;
  final List<AgentProductModel> products;

  const DiscoverSectionView(
      {super.key,
      required this.heading,
      required this.description,
      required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: context.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          description,
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 8),
        ProductsHorizontalView(
            products: products, productTileType: ProductTileType.viewProducts),
        const SizedBox(height: 24)
      ],
    );
  }
}
