// app/platforms/mobile/card_wallet/presentation/components/cart_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  void _showOrderConfirmation(BuildContext context) {
    // Clear the cart after order confirmation
    sl<InventoryBloc>().add(CartClearedEvent());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _OrderConfirmationSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventoryBloc = sl<InventoryBloc>();
    final cart = inventoryBloc.cart;
    final products = inventoryBloc.inventoryProductsResult?.products ?? [];
    final cartProducts =
        products.where((p) => cart.containsKey(p.productSkuUniqueId)).toList();
    final total = cartProducts.fold<double>(
      0,
      (sum, p) => sum + (p.productPrice * (cart[p.productSkuUniqueId] ?? 0)),
    );
    final canCheckout = total >= 500;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Your Cart',
              style:
                  context.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (cartProducts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text('Your cart is empty.'),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: cartProducts.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final product = cartProducts[index];
                    final quantity = cart[product.productSkuUniqueId] ?? 0;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.productImage.split(',').first,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: context.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${product.productCurrency} ${product.productPrice.toStringAsFixed(2)}",
                                style: context.labelMedium
                                    ?.copyWith(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: quantity > 1
                                  ? () => inventoryBloc.add(
                                      OnProductCardCountDecremented(
                                          productSkuUniqueId:
                                              product.productSkuUniqueId))
                                  : null,
                            ),
                            Text('$quantity', style: context.titleMedium),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => inventoryBloc.add(
                                  OnProductCardCountIncremented(
                                      productSkuUniqueId:
                                          product.productSkuUniqueId)),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style: context.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text(
                  total.toStringAsFixed(2),
                  style:
                      context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canCheckout ? Colors.black : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (canCheckout) {
                    _showOrderConfirmation(context);
                  } else {
                    ToastManager(
                      Toast(
                        title:
                            'For checkout, minimum order value is 500 dollars',
                        type: ToastificationType.error,
                      ),
                    ).show(context);
                  }
                },
                child: const Text('Checkout',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _OrderConfirmationSheet extends StatelessWidget {
  const _OrderConfirmationSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.green.withOpacity(0.12),
                      child: const Icon(Icons.check_circle,
                          color: Colors.green, size: 56),
                    ),
                  ),
                  Text(
                    'Your Order is Confirmed!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thank you for your purchase',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Contact Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    "We'll Be In Touch",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our Hushh team will contact you shortly with order details and next steps.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Have any questions? Reach out to us:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Email
                  _ContactItem(
                    icon: Icons.email_outlined,
                    label: 'info@hush1one.com',
                    onTap: () => launchUrl('mailto:info@hush1one.com'),
                  ),
                  const SizedBox(height: 10),
                  // Phone
                  _ContactItem(
                    icon: Icons.phone_outlined,
                    label: '+1 (425) 296-9050',
                    onTap: () => launchUrl('tel:+14252969050'),
                  ),
                ],
              ),
            ),
            // Company Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    'Hushh.ai',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.black,
                        child: const Icon(Icons.location_on_outlined,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('1021 5th St W',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                          Text('Kirkland, WA 98033',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Thank you for choosing Hushh',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Close',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ContactItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[200]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black,
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

void launchUrl(String url) async {
  // Use url_launcher or similar package in real app
}
