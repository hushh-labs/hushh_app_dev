// app/platforms/mobile/card_market/presentation/pages/discover_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/agent_horizontal_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/discover_section_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/discover_page_header.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/discover_page_search.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/cart_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/cached_inventory_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/data_sources/discover_page_data_source.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  final controller = sl<CardMarketBloc>();
  CardModel? selectedCard;

  @override
  void initState() {
    controller.add(FetchAgentsEvent());
    // Add all discover products to InventoryBloc for cart access using data source
    final allDiscoverProducts = DiscoverPageDataSource.getAllProducts();
    sl<InventoryBloc>().inventoryProductsResult =
        CachedInventoryModel(allDiscoverProducts.length, allDiscoverProducts);
    super.initState();
  }

  List<AgentModel> get filteredAgents => selectedCard == null
      ? controller.agents ?? []
      : (controller.agents ?? [])
          .where((element) => element.agentCard?.id == selectedCard!.id)
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              pinned: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const CartBottomSheet(),
                    );
                  },
                ),
                const SizedBox(width: 16)
              ],
              expandedHeight: 36.h + kTextTabBarHeight + kToolbarHeight,
              flexibleSpace: const DiscoverPageHeader(),
              backgroundColor: Colors.white,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                child: Container(
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 16, left: 12, right: 12),
                    child: DiscoverPageSearch(),
                  ),
                ),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12)
                      .copyWith(top: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  DiscoverSectionView(
                      heading: 'Hot Selling Skincare',
                      description: 'Browse the most popular skincare products',
                      products: DiscoverPageDataSource.getHotSellingProducts()),
                  DiscoverSectionView(
                      heading: 'Korean Beauty New Arrivals',
                      description: 'Fresh & Dynamic Korean skincare',
                      products: DiscoverPageDataSource.getKoreanBeautyProducts()),
                  BlocBuilder(
                      bloc: sl<CardMarketBloc>(),
                      builder: (context, state) {
                        final agents = sl<CardMarketBloc>().agents;
                        if (agents != null) {
                          return AgentHorizontalView(agents: agents);
                        }
                        return const SizedBox();
                      }),
                  DiscoverSectionView(
                      heading: 'Trending Hair Care',
                      description: 'Popular hair care essentials',
                      products: DiscoverPageDataSource.getTrendingHairCareProducts()),
                  DiscoverSectionView(
                      heading: 'Professional Hair Care',
                      description: 'Advanced hair treatment solutions',
                      products: DiscoverPageDataSource.getProfessionalHairCareProducts()),
                  DiscoverSectionView(
                      heading: 'Premium Skincare Treatments',
                      description: 'Luxury skincare for special care',
                      products: DiscoverPageDataSource.getPremiumSkincareProducts()),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
