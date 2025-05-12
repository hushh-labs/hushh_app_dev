import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/insights.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AiInsightsWidget extends StatefulWidget {
  final ReceiptInsights insights;

  const AiInsightsWidget({super.key, required this.insights});

  @override
  State<AiInsightsWidget> createState() => _AiInsightsWidgetState();
}

class _AiInsightsWidgetState extends State<AiInsightsWidget> {
  @override
  Widget build(BuildContext context) {
    Map<DateTime, Map<String, int>> dataByDateAndBrand = {};
    for (var shoppingDate in widget.insights.shoppingDates) {
      if (!dataByDateAndBrand.containsKey(shoppingDate.date)) {
        dataByDateAndBrand[shoppingDate.date] = {};
      }
      if (dataByDateAndBrand[shoppingDate.date]!
          .containsKey(shoppingDate.brandName)) {
        dataByDateAndBrand[shoppingDate.date]![shoppingDate.brandName] =
            dataByDateAndBrand[shoppingDate.date]![shoppingDate.brandName]! + 1;
      } else {
        dataByDateAndBrand[shoppingDate.date]![shoppingDate.brandName] = 1;
      }
    }

    // Prepare data for the bar chart
    List<BarChartGroupData> barChartData = [];
    int index = 0;
    for (var entry in dataByDateAndBrand.entries) {
      List<BarChartRodData> rodData = [];
      entry.value.forEach((brand, count) {
        rodData.add(BarChartRodData(
          toY: count.toDouble(),
          color: Colors.blue,
          width: 15,
        ));
      });
      barChartData.add(BarChartGroupData(
        x: index++,
        barRods: rodData,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Purchase Category:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 25.h,
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 20,
                sections: widget.insights.purchaseCategories.entries.map((entry) {
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    title: '${entry.key.replaceAll(" ", "\n")}',
                    titleStyle: TextStyle(fontSize: 14),
                    color: Color.fromRGBO(
                      entry.key.hashCode % 256,
                      (entry.key.length * 5) % 256,
                      (entry.key.length * 10) % 256,
                      1,
                    ),
                    radius: 100,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Competitor Receipts:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 20.h,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (widget.insights.competitorReceipts.isNotEmpty)
                  ? widget.insights.competitorReceipts.values
                          .reduce((a, b) => a > b ? a : b)
                          .toDouble() +
                      5
                  : 10,
              // default value if no data is available
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, t) => Text(
                    widget.insights.competitorReceipts.keys
                        .elementAt(value.toInt()),
                  ),
                )),
              ),
              borderData: FlBorderData(
                show: false,
              ),

              barGroups:
                  widget.insights.competitorReceipts.entries.map((entry) {
                return BarChartGroupData(
                  x: widget.insights.competitorReceipts.keys
                      .toList()
                      .indexOf(entry.key),
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      color: Colors.blue,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 32),
        // Text(
        //   'Date vs Brand',
        //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        // ),
        // SizedBox(height: 10),
        // SizedBox(
        //   height: 20.h,
        //   child: BarChart(
        //     BarChartData(
        //       alignment: BarChartAlignment.spaceAround,
        //       groupsSpace: 20,
        //       barTouchData: BarTouchData(enabled: false),
        //       titlesData: FlTitlesData(
        //         bottomTitles: AxisTitles(
        //             sideTitles: SideTitles(
        //           showTitles: true,
        //           getTitlesWidget: (value, t) => Text(
        //             dataByDateAndBrand.keys.toList()[value.toInt()].toString(),
        //           ),
        //         )),
        //       ),
        //       borderData: FlBorderData(
        //         show: false,
        //       ),
        //       barGroups: barChartData,
        //     ),
        //   ),
        // ),
        // SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Average Spending on Receipts:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.insights.spendingCapacity.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        )
      ],
    );
  }
}
