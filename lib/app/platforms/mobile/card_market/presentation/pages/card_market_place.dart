import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_market_brand_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_marketl_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/custom_card_market_tab_bar.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/search_card_list_view.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class CardMarketPlacePage extends StatefulWidget {
  const CardMarketPlacePage({Key? key}) : super(key: key);

  @override
  State<CardMarketPlacePage> createState() => _CardMarketPlacePageState();
}

class _CardMarketPlacePageState extends State<CardMarketPlacePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final controller = sl<CardMarketBloc>();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      setState(() {});
    });
    controller.add(FetchCardMarketEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey)),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: const Text(
          'Card Market',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            return controller.allCards == null
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color(0xFFE54D60),
                          Color(0xFFA342FF),
                        ])),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/hushh_coin.svg',
                              width: 18,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Get 50 coins for each card you add!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                hintText: 'Search for cards',
                                controller: controller.searchController,
                                focusNode: controller.searchFocusNode,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    controller.add(
                                        SearchCardInCardMarketEvent(value));
                                  } else {
                                    controller.searchListCards.clear();
                                    setState(() {});
                                  }
                                },
                              ),
                              if (controller.searchController.text
                                  .trim()
                                  .isEmpty)
                                CustomCardMarketTabBar(
                                  tabController: tabController,
                                  onValueChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        tabController.animateTo(value);
                                      }
                                    });
                                  },
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              controller.searchController.text.isNotEmpty
                                  ? SearchCardListView(
                                      searchListCards:
                                          controller.searchListCards,
                                    )
                                  : Expanded(
                                      child: TabBarView(
                                        controller: tabController,
                                        children: [
                                          CardMarketBrandListView(
                                            featuredCards:
                                                controller.featuredCard ?? [],
                                            otherCards:
                                                controller.brandCardData ?? [],
                                          ),
                                          CardMarketListView(
                                            canScroll: true,
                                            cards: controller.generalCardData ??
                                                [],
                                          ),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
          }),
    );
  }
}
