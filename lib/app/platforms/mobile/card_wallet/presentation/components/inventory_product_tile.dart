import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get_it/get_it.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class InventoryProductTile extends StatefulWidget {
  final AgentProductModel product;
  final VoidCallback? onLongPress;

  const InventoryProductTile({
    Key? key,
    required this.product,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<InventoryProductTile> createState() => _InventoryProductTileState();
}

class _InventoryProductTileState extends State<InventoryProductTile>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _controller.addListener(() {
      setState(() {
        _scale = _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  void _showInventoryManagementOptions(BuildContext context) {
    final inventoryBloc = sl<InventoryBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Always get the latest product from the BLoC by SKU
            final latestProduct =
                inventoryBloc.inventoryProductsResult?.products.firstWhere(
              (p) => p.productSkuUniqueId == widget.product.productSkuUniqueId,
              orElse: () => widget.product,
            );
            int tempStock =
                latestProduct?.stockQuantity ?? widget.product.stockQuantity;
            final TextEditingController stockController =
                TextEditingController(text: tempStock.toString());
            bool isLoading = false;
            String? errorText;
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
                      'Manage ${latestProduct?.productName ?? widget.product.productName}',
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
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Increase Stock',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                                color:
                                    tempStock > 0 ? Colors.white : Colors.grey),
                            label: Text('Decrease Stock',
                                style: TextStyle(
                                    color: tempStock > 0
                                        ? Colors.white
                                        : Colors.grey)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  tempStock > 0 ? Colors.red : Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                                      latestProduct?.productSkuUniqueId ??
                                          widget.product.productSkuUniqueId,
                                  newStockQuantity: parsed,
                                ));
                                // Wait for the BLoC to fetch new data
                                await Future.delayed(
                                    const Duration(milliseconds: 600));
                                if (context.mounted) Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('Save',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
                          ),
                    const SizedBox(height: 12),
                    Text(
                      'Current Stock: ${latestProduct?.stockQuantity ?? widget.product.stockQuantity}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final bool outOfStock = product.stockQuantity == 0;
    final bool inStock = product.stockQuantity > 0;
    final theme = Theme.of(context);
    return GestureDetector(
      onLongPress: () => _showInventoryManagementOptions(context),
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          height: 30.h,
          width: 30.h * 0.667,
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main card content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image with badge overlay
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: product.productImage.isNotEmpty
                            ? Image.network(
                                product.productImage.split(',').first,
                                width: double.infinity,
                                height: 130,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: double.infinity,
                                height: 130,
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
                      // Pill badge (top left)
                      Positioned(
                        top: 14,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: outOfStock
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                outOfStock
                                    ? Icons.close_rounded
                                    : Icons.check_circle_rounded,
                                size: 16,
                                color: outOfStock
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                outOfStock ? 'Out of Stock' : 'In Stock',
                                style: TextStyle(
                                  color: outOfStock
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Edit floating button
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => _showInventoryManagementOptions(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Divider or color block
                  Container(
                    height: 1.5,
                    width: double.infinity,
                    color: Colors.grey[200],
                    margin: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  // Product details
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (product.productSkuUniqueId.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            child: Text(
                              'SKU: ${product.productSkuUniqueId}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          '${product.productCurrency} ${product.productPrice}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Stock label (bottom right of card)
              Positioned(
                right: 14,
                bottom: 14,
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
            ],
          ),
        ),
      ),
    );
  }
}
