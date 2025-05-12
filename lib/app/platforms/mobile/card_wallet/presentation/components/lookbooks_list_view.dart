import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tuple/tuple.dart';

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
                if(sendLookBook) {
                  Navigator.pop(context, [lookbook]);
                  return;
                }
                controller.selectedLookBook = lookbook;
                Navigator.pushNamed(
                  context,
                  AppRoutes.agentProducts,
                  arguments: Tuple3<AgentProductsPageStatus, String?,
                          List<AgentProductModel>?>(
                      AgentProductsPageStatus.lookbookOpened,
                      lookbook.id,
                      null),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                    children: List.generate(
                        lookbook.images.length,
                        (index) => Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFeaeff3),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: NetworkImage(lookbook.images[index]
                                          .split(',')
                                          .first))),
                            ))
                      ..add(lookbook.images.length == 3 &&
                              (lookbook.numberOfProducts -
                                      lookbook.images.length) >
                                  0
                          ? Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFeaeff3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "+${lookbook.numberOfProducts - lookbook.images.length}",
                                  style: context.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFA2A2A2)),
                                ),
                              ),
                            )
                          : const SizedBox()),
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
