import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_insights/expenses_preview.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_insights.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/app_usage_card.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'insights_models.dart';

class SpendingCard extends StatelessWidget {
  final SpendingData? spendingData;
  final DateTime? oldestReceiptDate;

  const SpendingCard(this.spendingData,
      {super.key, required this.oldestReceiptDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
                'Total Spending (since: ${oldestReceiptDate == null ? "" : DateFormat('dd MMM, yyyy').format(oldestReceiptDate!)})',
                style: context.titleMedium),
            if(AppLocalStorage.isReceiptRadarFetchingReceipts) ...[
              const SizedBox(width: 8),
              const CupertinoActivityIndicator(radius: 8)
            ]
          ],
        ),
        Text(
            '${sl<HomePageBloc>().currency.shorten()}${NumberFormat().format(spendingData?.totalSpending ?? 0.00)}',
            style:
                context.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
        Text(
            'Last 30 Days ${spendingData?.changePercentage.isNegative ?? true ? '' : '+'}${spendingData?.changePercentage.toStringAsFixed(2) ?? '0'}%',
            style: TextStyle(
                color: spendingData?.changePercentage.isNegative ?? true
                    ? Colors.redAccent
                    : Colors.green)),
        Text(
            'Average per Transaction ${sl<HomePageBloc>().currency.shorten()}${spendingData?.averageTransaction.toString().split('.').firstOrNull ?? "0"}',
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class BrandList extends StatelessWidget {
  final String title;
  final List<Brand> brands;

  const BrandList({super.key, required this.title, required this.brands});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: context.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8.0),
        Wrap(
          children: brands.map((brand) {
            return brand.logo?.isNotEmpty ?? false
                ? Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(brand.logo!),
                      ),
                    ),
                  )
                : const SizedBox();
          }).toList(),
        ),
      ],
    );
  }
}

class CategoryList extends StatelessWidget {
  final String title;
  final List<ExpenseCategory> categories;

  const CategoryList(
      {super.key, required this.title, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: context.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ...categories.map(
          (category) => ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () async {
              sl<ReceiptRadarBloc>()
                  .filterBasedReceipts = sl<ReceiptRadarBloc>()
                      .receipts
                      ?.where(
                          (element) => category.receiptIds.contains(element.messageId))
                      .toList() ??
                  [];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExpensesPreview(
                            title: category.name.easy(),
                          )));
            },
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: Text(category.name.easy()),
            subtitle: Text('${category.receiptIds.length} receipts'),
            trailing: Text(
                '${category.currency.shorten()}${category.amount.toStringAsFixed(2)}'),
          ),
        ),
      ],
    );
  }
}

class SpendingByBrand extends StatelessWidget {
  final List<MapEntry<String, double>> spendingData;

  const SpendingByBrand(this.spendingData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Spending By Brand',
            style: context.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8.0),
        ...spendingData.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key.capitalize()),
                const SizedBox(width: 8.0),
                Expanded(
                  child: LinearProgressIndicator(
                    value: entry.value / 100,
                    minHeight: 20,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text('${(entry.value).toStringAsFixed(2)}%'),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

class AppUsageByBrand extends StatefulWidget {
  final String hushhId;
  final int cardCategoryId;

  const AppUsageByBrand(
      {super.key, required this.hushhId, required this.cardCategoryId});

  @override
  State<AppUsageByBrand> createState() => _AppUsageByBrandState();
}

class _AppUsageByBrandState extends State<AppUsageByBrand> {
  AppUsageInsights? appUsageInsight;

  Stream<dynamic> getUserAppUsageSummaryStream(
      String hushhId, int cardCategoryId) {
    return Supabase.instance.client.rpc(
      'get_category_usage_stats',
      params: {
        'p_hushh_id': hushhId,
        'p_interval': '24 hours',
        'p_brand_category_id': cardCategoryId
      },
    ).asStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            getUserAppUsageSummaryStream(widget.hushhId, widget.cardCategoryId),
        builder: (context, state) {
          if (state.data != null) {
            final appUsageInsights = (state.data as List)
                .map((e) => AppUsageInsights.fromJson(e))
                .toList();
            if (appUsageInsights.isNotEmpty) {
              appUsageInsight = appUsageInsights.first;
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Activity',
                  style: context.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8.0),
              IgnorePointer(
                ignoring: true,
                child: UsageCard(
                  title: appUsageInsight?.categoryName ?? "",
                  hours: Utils().formatDuration(
                      appUsageInsight?.totalTimeSpent ?? 0),
                  percentage: 'Last Week',
                  color: Colors.black,
                  apps: appUsageInsight?.apps ?? [],
                ),
              )
            ],
          );
        });
  }
}

class CategoryPieChart extends StatefulWidget {
  final List<ExpenseCategory> categories;
  final bool fromHome;

  const CategoryPieChart(
      {super.key, required this.categories, this.fromHome = false});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return _buildPieChart(Map<BrandCategoryEnum, double>.fromEntries(
      widget.categories.map((e) {
        // Calculate total amount
        double totalAmount =
            widget.categories.fold(0, (sum, category) => sum + category.amount);
        // Convert amount to percentage
        double percentage = (e.amount / totalAmount) * 100;
        return MapEntry(e.name, percentage);
      }).toList(),
    ));
  }

  Widget _buildPieChart(Map<BrandCategoryEnum, double> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          child: Transform.scale(
            scale: .6,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }

                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 6,
                centerSpaceRadius: 55.5,
                sections: _generatePieChartSections(categories),
                startDegreeOffset: -90,
              ),
            ),
          ),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: _buildCategoryLegend(categories))
      ],
    );
  }

  List<PieChartSectionData> _generatePieChartSections(
      Map<BrandCategoryEnum, double> categories) {
    return List.generate(
        categories.length,
        (index) => PieChartSectionData(
              color: categories.keys.elementAt(index).color(),
              value: categories.values.elementAt(index),
              showTitle: false,
              badgePositionPercentageOffset: 2,
              badgeWidget: touchedIndex == index
                  ? _buildLegendItem(categories.keys.elementAt(index),
                      categories.keys.elementAt(index).color(),
                      fromPi: true)
                  : null,
              title: categories.keys.elementAt(index).easy(),
              radius: 80,
            ));
  }

  Widget _buildCategoryLegend(Map<BrandCategoryEnum, double> categories) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // For a nice scroll effect
        child: Row(
          children: List.generate(
              categories.length,
              (index) => Padding(
                    padding: EdgeInsets.only(
                        right: 8.0,
                        left: index == 0 && widget.fromHome ? 16 : 0),
                    child: _buildLegendItem(categories.keys.elementAt(index),
                        categories.keys.elementAt(index).color()),
                  )),
        ),
      ),
    );
  }

  Widget _buildLegendItem(BrandCategoryEnum label, Color color,
      {bool fromPi = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Makes container wrap its content
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label.easy(),
            style: TextStyle(
              fontSize: fromPi ? 14 : 10,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
