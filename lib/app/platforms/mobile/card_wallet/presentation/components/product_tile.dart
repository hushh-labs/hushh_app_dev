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
  final VoidCallback? onLongPress;

  const ProductTile(
      {super.key,
      required this.product,
      this.specifyDimensions = false,
      required this.productTileType,
      required this.isProductSelected,
      required this.onProductClicked,
      required this.onProductInventoryIncremented,
      required this.onProductInventoryDecremented,
      this.onLongPress});

  bool get isRecentProduct => DateTime.now()
      .subtract(const Duration(days: 1))
      .isAfter(product.createdAt ?? DateTime.now());

  void _showInventoryManagementOptions(BuildContext context) {
    if (sl<CardWalletPageBloc>().isAgent) {
      int tempStock = product.stockQuantity;
      final TextEditingController stockController =
          TextEditingController(text: tempStock.toString());
      bool isLoading = false;
      String? errorText;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
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
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        setModalState(() {
                                          tempStock++;
                                          stockController.text =
                                              tempStock.toString();
                                          errorText = null;
                                        });
                                      },
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                label: const Text('Increase Stock',
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isLoading || tempStock <= 0
                                    ? null
                                    : () {
                                        setModalState(() {
                                          tempStock =
                                              tempStock > 0 ? tempStock - 1 : 0;
                                          stockController.text =
                                              tempStock.toString();
                                          errorText = null;
                                        });
                                      },
                                icon: Icon(Icons.remove,
                                    color: tempStock > 0
                                        ? Colors.white
                                        : Colors.grey),
                                label: Text('Decrease Stock',
                                    style: TextStyle(
                                        color: tempStock > 0
                                            ? Colors.white
                                            : Colors.grey)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: tempStock > 0
                                      ? Colors.red
                                      : Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Set Stock Quantity',
                            errorText: errorText,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            setModalState(() {
                              final parsed = int.tryParse(value);
                              if (parsed != null && parsed >= 0) {
                                tempStock = parsed;
                                errorText = null;
                              } else {
                                errorText = 'Enter a valid non-negative number';
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final parsed =
                                        int.tryParse(stockController.text);
                                    if (parsed == null || parsed < 0) {
                                      setModalState(() {
                                        errorText =
                                            'Enter a valid non-negative number';
                                      });
                                      return;
                                    }
                                    setModalState(() {
                                      isLoading = true;
                                      errorText = null;
                                    });
                                    // Dispatch BLoC event to update stock
                                    sl<InventoryBloc>()
                                        .add(UpdateProductStockQuantityEvent(
                                      productSkuUniqueId:
                                          product.productSkuUniqueId,
                                      newStockQuantity: parsed,
                                    ));
                                    // Wait a short moment for UI update (or listen for state in parent for better UX)
                                    await Future.delayed(
                                        const Duration(milliseconds: 400));
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  child: const Text('Save',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ),
                              ),
                        const SizedBox(height: 12),
                        Text(
                          'Current Stock: $tempStock',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = sl<LookBookProductBloc>();
    bool isAgent = sl<CardWalletPageBloc>().isAgent;
    return GestureDetector(
      onTap: () {
        onProductClicked(product.productSkuUniqueId);
      },
      onLongPress:
          onLongPress ?? () => _showInventoryManagementOptions(context),
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
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: double.infinity,
                                  color: Colors.grey[100],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print(
                                    '📊 [IMAGE] Error loading image: ${product.productImage}');
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
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 6,
                bottom: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.stockQuantity > 0
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color:
                          product.stockQuantity > 0 ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    product.stockQuantity > 0
                        ? 'Stock: ${product.stockQuantity}'
                        : 'Out of Stock',
                    style: TextStyle(
                      fontSize: 12,
                      color: product.stockQuantity > 0
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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
              else if (productTileType == ProductTileType.viewProducts)
                Align(
                  alignment: Alignment.bottomRight,
                  child: isAgent
                      ? Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                          ),
                        )
                      : BlocBuilder(
                          bloc: sl<InventoryBloc>(),
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: sl<InventoryBloc>()
                                          .cart[product.productSkuUniqueId] ==
                                      null
                                  ? () {
                                      if (sl<InventoryBloc>().cart[
                                              product.productSkuUniqueId] ==
                                          null) {
                                        onProductInventoryIncremented(
                                            product.productSkuUniqueId);
                                      }
                                    }
                                  : null,
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
                                            onTap: () {
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
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
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
                                        Icons.add,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                              ),
                            );
                          }),
                ),
              if (!isAgent)
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
