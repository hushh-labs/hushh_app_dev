import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_products.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class LookBooksListView extends StatelessWidget {
  final List<AgentLookBook> lookbooks;
  final bool fromChat;
  final bool sendLookBook;

  const LookBooksListView(
      {super.key,
      required this.lookbooks,
      this.fromChat = false,
      this.sendLookBook = false});

  @override
  Widget build(BuildContext context) {
    final controller = sl<LookBookProductBloc>();
    return GridView.builder(
      shrinkWrap: true,
      physics: fromChat ? const NeverScrollableScrollPhysics() : null,
      itemCount: lookbooks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: fromChat ? 1 : 2,
          childAspectRatio: fromChat ? 1 : .7),
      itemBuilder: (context, index) {
        final lookbook = lookbooks[index];
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
                    onPressed: () {
                      controller.add(DeleteLookBookEvent(lookbook, context));
                    }),
              ],
              onPressed: () {
                print('📖 [LOOKBOOK] Lookbook tapped: ${lookbook.name}');
                if (sendLookBook) {
                  Navigator.pop(context, [lookbook]);
                  return;
                }
                controller.selectedLookBook = lookbook;
                print(
                    '📖 [LOOKBOOK] Navigating to agent products with lookbook: ${lookbook.id}');
                Navigator.pushNamed(
                  context,
                  AppRoutes.agentProducts,
                  arguments: AgentProductsArgs(
                    productTileType: ProductTileType.viewProducts,
                    lookbookId: lookbook.id,
                    products: null,
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, gridIndex) {
                      // If there are more than 4 products, last cell is '+N'
                      if (gridIndex == 3 && lookbook.numberOfProducts > 4) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFeaeff3),
                            borderRadius: BorderRadius.circular(8),
                            image: lookbook.images.length > 3
                                ? DecorationImage(
                                    image: NetworkImage(
                                        lookbook.images[3].split(',').first),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "+${lookbook.numberOfProducts - 3}",
                                style: context.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }
                      // Show image if available
                      if (gridIndex < lookbook.images.length) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFeaeff3),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(
                                  lookbook.images[gridIndex].split(',').first),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                      // Otherwise, show empty placeholder
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFeaeff3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (!fromChat) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  lookbook.name,
                  style: context.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Last updated: ${timeago.format(DateTime.parse(lookbook.createdAt))}",
                  style: context.titleSmall
                      ?.copyWith(color: const Color(0xFF637087)),
                ),
              ),
            ]
          ],
        );
      },
    );
  }
}
