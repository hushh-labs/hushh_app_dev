import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/products_grid_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/inventory_product_tile.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class InventoryProductsPageArgs {
  final ProductTileType productTileType;
  final int configurationId;
  final int brandId;

  InventoryProductsPageArgs({
    required this.productTileType,
    required this.configurationId,
    required this.brandId,
  });
}

class InventoryProductsPage extends StatefulWidget {
  const InventoryProductsPage({super.key});

  @override
  State<InventoryProductsPage> createState() => _InventoryProductsPageState();
}

class _InventoryProductsPageState extends State<InventoryProductsPage> {
  final controller = sl<InventoryBloc>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final InventoryProductsPageArgs res = ModalRoute.of(context)!
          .settings
          .arguments! as InventoryProductsPageArgs;
      controller
          .add(FetchProductsInInventoryEvent(res.configurationId, res.brandId));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments!
        as InventoryProductsPageArgs;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset('assets/back.svg')),
        ),
        centerTitle: false,
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder(
            bloc: controller,
            builder: (context, state) {
              if (state is FetchProductsResultFromInventoryState) {
                return const Center(child: CupertinoActivityIndicator());
              }
              if (state is ProductsResultFetchedFromInventoryState) {
                final products = state.products;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: .65,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return InventoryProductTile(
                      product: product,
                      onLongPress: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Manage ${product.productName}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              sl<InventoryBloc>().add(
                                                  IncrementProductStockEvent(
                                                productSkuUniqueId:
                                                    product.productSkuUniqueId,
                                              ));
                                            },
                                            icon: const Icon(Icons.add,
                                                color: Colors.white),
                                            label: const Text('Increase Stock',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: product.stockQuantity > 0
                                                ? () {
                                                    Navigator.pop(context);
                                                    sl<InventoryBloc>().add(
                                                        DecrementProductStockEvent(
                                                      productSkuUniqueId: product
                                                          .productSkuUniqueId,
                                                    ));
                                                  }
                                                : null,
                                            icon: Icon(Icons.remove,
                                                color: product.stockQuantity > 0
                                                    ? Colors.white
                                                    : Colors.grey),
                                            label: Text('Decrease Stock',
                                                style: TextStyle(
                                                    color:
                                                        product.stockQuantity >
                                                                0
                                                            ? Colors.white
                                                            : Colors.grey)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  product.stockQuantity > 0
                                                      ? Colors.red
                                                      : Colors.grey[300],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Current Stock: ${product.stockQuantity}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              }
              // fallback: show empty or previous products if needed
              return const SizedBox.shrink();
            }),
      ),
    );
  }
}
