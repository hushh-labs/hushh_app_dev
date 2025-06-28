import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductTile extends StatelessWidget {
  final AgentProductModel product;
  final bool specifyDimensions;
  final ProductTileType productTileType;
  final bool isProductSelected;
  final Function(String) onProductClicked;
  final Function(String) onProductInventoryIncremented;
  final Function(String) onProductInventoryDecremented;

  const ProductTile(
      {super.key,
      required this.product,
      this.specifyDimensions = false,
      required this.productTileType,
      required this.isProductSelected,
      required this.onProductClicked,
      required this.onProductInventoryIncremented,
      required this.onProductInventoryDecremented});

  bool get isRecentProduct => DateTime.now()
      .subtract(const Duration(days: 1))
      .isAfter(product.createdAt ?? DateTime.now());

  @override
  Widget build(BuildContext context) {
    final controller = sl<LookBookProductBloc>();
    bool isAgent = sl<CardWalletPageBloc>().isAgent;
    return GestureDetector(
      onTap: () {
        onProductClicked(product.productSkuUniqueId);
      },
      child: SizedBox(
        height: specifyDimensions ? 30.h : 0,
        width: specifyDimensions ? 30.h * 0.667 : 0,
        child: Card(
          color: Colors.white,
          elevation: .5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isProductSelected
                ? const BorderSide(color: Colors.black, width: 1)
                : BorderSide.none,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      child: product.productImage.isNotEmpty
                          ? Image.network(
                              product.productImage.split(',').first,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: double.infinity,
                                  color: Colors.grey[100],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('📊 [IMAGE] Error loading image: ${product.productImage}');
                                print('📊 [IMAGE] Error: $error');
                                return Container(
                                  width: double.infinity,
                                  color: Colors.grey[100],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: double.infinity,
                              color: Colors.grey[100],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No image',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            product.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: context.titleMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      "${Utils().getCurrencyFromCurrencySymbol(product.productCurrency)?.shorten() ?? ("${product.productCurrency} ")}${product.productPrice}",
                                ),
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: "${product.productPrice + 2100}",
                                  style: const TextStyle(
                                      color: Color(0xFF637087),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              if (isProductSelected)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            topLeft: Radius.circular(8))),
                    child: const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                )
              else if (productTileType == ProductTileType.selectProducts)
                const SizedBox()
              else
                Align(
                  alignment: Alignment.bottomRight,
                  child: BlocBuilder(
                      bloc: sl<InventoryBloc>(),
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: sl<InventoryBloc>().cart[product.productSkuUniqueId] == null?() {
                            if(sl<InventoryBloc>().cart[product.productSkuUniqueId] == null) {
                              onProductInventoryIncremented(
                                product.productSkuUniqueId);
                            }
                          }:null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(8),
                                    topLeft: Radius.circular(8))),
                            child: sl<InventoryBloc>()
                                    .cart
                                    .containsKey(product.productSkuUniqueId)
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          onProductInventoryDecremented(
                                              product.productSkuUniqueId);
                                        },
                                        child: const Icon(
                                          Icons.remove,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${sl<InventoryBloc>().cart[product.productSkuUniqueId]!}',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: (){
                                          onProductInventoryIncremented(
                                              product.productSkuUniqueId);
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : Icon(
                                    productTileType ==
                                            ProductTileType.viewProducts
                                        ? Icons.add
                                        : Icons.info_outline,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                          ),
                        );
                      }),
                ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.redAccent.withOpacity(.8),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: isRecentProduct ? Colors.black : Colors.yellow,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      child: Text(
                        isRecentProduct ? 'NEW' : '20%',
                        style: TextStyle(
                            fontSize: 12,
                            color: isRecentProduct
                                ? Colors.white
                                : Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
