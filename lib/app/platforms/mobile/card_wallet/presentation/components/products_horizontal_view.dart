// app/platforms/mobile/card_wallet/presentation/components/products_horizontal_view.dart
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/product_tile.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class ProductsHorizontalView extends StatefulWidget {
  final List<AgentProductModel> products;
  final ProductTileType productTileType;

  const ProductsHorizontalView(
      {super.key, required this.products, required this.productTileType});

  @override
  State<ProductsHorizontalView> createState() => _ProductsHorizontalViewState();
}

class _ProductsHorizontalViewState extends State<ProductsHorizontalView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      bloc: sl<InventoryBloc>(),
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                widget.products.length,
                (index) => Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ProductTile(
                        specifyDimensions: true,
                        onProductClicked: (squId) {},
                        onProductInventoryIncremented: (squId) {
                          sl<InventoryBloc>().add(OnProductCardCountIncremented(
                              productSkuUniqueId: squId));
                        },
                        onProductInventoryDecremented: (squId) {
                          sl<InventoryBloc>().add(OnProductCardCountDecremented(
                              productSkuUniqueId: squId));
                        },
                        isProductSelected: false,
                        productTileType: widget.productTileType,
                        product: widget.products[index],
                      ),
                    )),
          ),
        );
      },
    );
  }
}
