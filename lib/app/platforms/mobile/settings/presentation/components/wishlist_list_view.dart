import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_collection.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/wishlist_products.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WishlistListView extends StatelessWidget {
  final List<BrowsedCollection> collections;

  const WishlistListView({super.key, required this.collections});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: collections.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 16, crossAxisCount: 2, childAspectRatio: .8),
      itemBuilder: (context, index) {
        final collection = collections[index];
        final products = collection.products;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FocusedMenuHolder(
              menuWidth: 50.w,
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(
                    title: const Text('Open'),
                    trailingIcon: const Icon(Icons.open_in_new),
                    onPressed: () async {}),
                FocusedMenuItem(
                    title: const Text("Share"),
                    trailingIcon: const Icon(Icons.share),
                    onPressed: () {}),
                FocusedMenuItem(
                    backgroundColor: Colors.red,
                    title: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailingIcon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {}),
              ],
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.wishlistProducts,
                    arguments: WishlistProductsArgs(products, collection.name, collectionId: collection.collectionId));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                    children: List.generate(
                        products.length > 4 ? 4 : products.length, (index) {
                      final product = products[index];
                      return Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFeaeff3),
                            borderRadius: BorderRadius.circular(8),
                            image: product.imageUrl == null
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.topCenter,
                                    image: NetworkImage(product.imageUrl!))),
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "${collection.name} (${collection.products.length})",
                style: context.titleMedium,
              ),
            ),
          ],
        );
      },
    );
  }
}
