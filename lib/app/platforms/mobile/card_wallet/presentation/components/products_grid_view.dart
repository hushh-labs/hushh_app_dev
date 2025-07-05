import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/product_tile.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class ProductsGridView extends StatelessWidget {
  final List<AgentProductModel> products;
  final ProductTileType productTileType;
  final bool fromCardView;

  ProductsGridView(
      {super.key,
      required this.products,
      required this.productTileType,
      this.fromCardView = false});

  final controller = sl<InventoryBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      bloc: controller,
      builder: (context, state) {
        final selectedProductIds = controller.selectedProductIds;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: .65,
          ),
          padding: fromCardView ? EdgeInsets.zero : null,
          shrinkWrap: fromCardView ? true : false,
          physics: fromCardView ? const NeverScrollableScrollPhysics() : null,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final isSelected =
                selectedProductIds.contains(product.productSkuUniqueId);

            return ProductTile(
              product: product,
              isProductSelected: isSelected,
              onProductClicked: (skuId) {
                if (productTileType == ProductTileType.selectProducts) {
                  controller.add(OnProductSelectEvent(
                    productSkuUniqueId: skuId,
                    isSelected: !isSelected,
                  ));
                }
              },
              onProductInventoryIncremented: (skuId) {
                if (productTileType == ProductTileType.viewProducts) {
                  controller.add(
                      OnProductCardCountIncremented(productSkuUniqueId: skuId));
                }
              },
              onProductInventoryDecremented: (skuId) {
                if (productTileType == ProductTileType.viewProducts) {
                  controller.add(
                      OnProductCardCountDecremented(productSkuUniqueId: skuId));
                }
              },
              productTileType: productTileType == ProductTileType.editProducts
                  ? ProductTileType.editProducts
                  : productTileType,
            );
          },
        );
      },
    );
  }
}
