import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class WishlistProductsArgs {
  final List<BrowsedProduct> products;
  final String title;
  final String? collectionId;

  WishlistProductsArgs(this.products, this.title, {this.collectionId});
}

class WishlistProducts extends StatefulWidget {
  const WishlistProducts({super.key});

  @override
  State<WishlistProducts> createState() => _WishlistProductsState();
}

class _WishlistProductsState extends State<WishlistProducts> {
  List<BrowsedProduct> products = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args =
          ModalRoute.of(context)?.settings.arguments as WishlistProductsArgs;
      products = List.from(args.products);
      products.sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as WishlistProductsArgs;
    final title = args.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (args.collectionId != null)
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  onPressed: () {
                    Share.share(
                        'https://browser-companion-dashboard.vercel.app/?collectionId=${args.collectionId}&version=1.3');
                  },
                  icon: const Icon(Icons.share)),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: products.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: .8),
          itemBuilder: (context, index) {
            final product = products[index];
            return FocusedMenuHolder(
              menuWidth: 50.w,
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(
                    title: const Text('Visit'),
                    trailingIcon: const Icon(Icons.open_in_new),
                    onPressed: () async {
                      launchUrl(Uri.parse(product.productUrl));
                    }),
                FocusedMenuItem(
                    title: const Text("Share"),
                    trailingIcon: const Icon(Icons.share),
                    onPressed: () {
                      Share.share(product.productUrl);
                    }),
                FocusedMenuItem(
                    backgroundColor: Colors.red,
                    title: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailingIcon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      ToastManager(Toast(
                              title: "Coming Soon",
                              type: ToastificationType.info))
                          .show(context);
                    }),
              ],
              onPressed: () {
                launchUrl(Uri.parse(product.productUrl));
              },
              child: Stack(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            image: product.imageUrl == null
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: NetworkImage(product.imageUrl!))),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                    0,
                                    0.55
                                  ],
                                  colors: [
                                    Colors.transparent,
                                    Colors.black45
                                  ])),
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    product.productTitle ?? 'N/A',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    DateFormat("dd MMM, yyyy hh:mm aa")
                                        .format(product.timestamp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.bodySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
