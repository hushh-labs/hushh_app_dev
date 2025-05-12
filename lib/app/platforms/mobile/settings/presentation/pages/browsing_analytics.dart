import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/wishlist_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/wishlist_products.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/ai_handler/prompt_gen.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class BrowsingAnalytics extends StatefulWidget {
  const BrowsingAnalytics({super.key});

  @override
  State<BrowsingAnalytics> createState() => _BrowsingAnalyticsState();
}

class _BrowsingAnalyticsState extends State<BrowsingAnalytics> {
  final controller = sl<SettingsPageBloc>();
  final Map<int, Color> colors = {
    0: const Color(0xFFE44D62),
    1: const Color(0xFF4DE477),
    2: const Color(0xFFFFE142),
    3: const Color(0xFFA342FF),
  };

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final hushhId = ModalRoute.of(context)!.settings.arguments as String?;
      if (hushhId != null) {
        controller.add(FetchUserTypeBasedOnBrowsingBehaviourEvent(hushhId));
        controller.add(FetchProductsBasedOnBrowsingBehaviourEvent(hushhId));
        controller
            .add(FetchBrowsedCollectionsBasedOnBrowsingBehaviourEvent(hushhId));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (controller.allBrowsedProducts?.isNotEmpty ?? false) {
                Navigator.pushNamed(context, AppRoutes.chat.ai,
                    arguments: PromptGen.hushhBotWithProducts(
                        controller.allBrowsedProducts!));
              }
            },
            style: ElevatedButton.styleFrom(
                elevation: 0, foregroundColor: const Color(0xFFE51A5E)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_outlined,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text('Chat w/ Hushh AI')
              ],
            ),
          ),
          JustTheTooltip(
            content: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'All your searches and favourite brands are shown here from our Browser Companion.',
              ),
            ),
            backgroundColor: Colors.grey.shade300,
            triggerMode: TooltipTriggerMode.tap,
            enableFeedback: true,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.help_outline,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            List<BrowsedProduct> sortedProducts =
                controller.allBrowsedProducts?.toList() ?? [];
            sortedProducts.sort((a, b) => a.timestamp.compareTo(b.timestamp));
            List<String> sortedProductsAsString = sortedProducts
                .map((e) => e.brand?.brandName ?? "Unavailable")
                .toSet()
                .take(3)
                .toList();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type of User',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      'Based on Your Activity and Time Spent You are a',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.browsingBehaviourPersonType == DayNight.night
                          ? '🦉 Night OWL'
                          : '🐥 Early Bird',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.indigo),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Recents',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: (sortedProductsAsString
                              .map((e) => _buildSearchChip(e))
                              .toList()) ??
                          List.filled(6, _buildSearchChip(null)),
                    ),
                    const SizedBox(height: 26),
                    if (controller.topSearchBrands?.isNotEmpty ?? false) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Top Browsed Brands',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.wishlistProducts,
                                  arguments: WishlistProductsArgs(
                                      controller.allBrowsedProducts!,
                                      'All Products'));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('SEE ALL',
                                  style: TextStyle(
                                      color: Color(0xFFE51A5E),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFFE51A5E))),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      AspectRatio(aspectRatio: 1.5, child: _buildPieChart()),
                    ],
                    const SizedBox(height: 26),
                    const Text(
                      'Things You Want',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    if (controller.collections?.isNotEmpty ?? false)
                      WishlistListView(collections: controller.collections!)
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildSearchChip(String? label) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: Colors.grey.shade800,
        child: Center(
            child: Text(
          label?[0].toUpperCase() ?? "-",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        )),
      ),
      label: Text(label ?? "----"),
    ).toShimmer(label == null);
  }

  Widget _buildPieChart() {
    Color generateColorFromName(String name) {
      final int hashCode = name.hashCode & 0x00FFFFFF; // Ensure positive value
      return Color(hashCode).withOpacity(1.0); // Generate color from hash code
    }

    controller.allBrowsedProducts
        ?.where((element) => element.brand != null)
        .forEach((product) {
      final brandName = product.brand!.brandName;
      controller.brandCounts[brandName] =
          (controller.brandCounts[brandName] ?? 0) + 1;
    });
    int totalCount =
        controller.brandCounts.values.fold(0, (sum, count) => sum + count);
    List<Brand>? list = controller.topSearchBrands?.take(4).toList();
    return PieChart(
      PieChartData(
          sections: List.generate(
            list?.length ?? 0,
            (index) {
              final brand = list![index];
              final count = controller.brandCounts[brand.brandName] ?? 0;
              final double percentage = (count / totalCount) * 100;
              return PieChartSectionData(
                color: colors[index],
                value: percentage,
                title: list[index].brandName,
                radius: 100,
              );
            },
          ),
          sectionsSpace: 0),
    );
  }
}
