import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';

class AppUsageBarChart extends StatefulWidget {
  final List<AppUsageData> allAppUsageData;

  const AppUsageBarChart({super.key, required this.allAppUsageData});

  @override
  State<AppUsageBarChart> createState() => _AppUsageBarChartState();
}

class _AppUsageBarChartState extends State<AppUsageBarChart> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        // itemCount: widget.allAppUsageData.isEmpty
        //     ? 1
        //     : _getTotalWeeks() == 0
        //         ? 1
        //         : _getTotalWeeks(),
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final weeklyData = _getWeeklyDataForPage(index);
          final maxUsage = _getMaxUsage(weeklyData);
          final yMax = (maxUsage * 1.5)
              .ceilToDouble(); // Set y-axis max as twice the max usage
          final yInterval =
              (yMax / 5).ceilToDouble(); // Adjust interval accordingly

          return _buildBarChart(weeklyData, yMax, yInterval);
        },
      ),
    );
  }

  Widget _buildBarChart(
      List<AppUsageData> weeklyData, double yMax, double yInterval) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: yMax,
          barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.transparent,
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem(
                      Utils().formatDurationFromDouble(rod.toY),
                      const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  })),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: yInterval == 0 ? null : yInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _formatUsageLabel(value),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  return Text(
                    _getDayLabel(index),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          barGroups: _generateBarGroups(weeklyData),
        ),
      ),
    );
  }

  String _formatUsageLabel(double value) {
    // If usage is less than 1 hour, display in minutes
    if (value < 1) {
      return '${(value * 60).toInt()}m'; // Convert to minutes
    }
    return '${value.toInt()}h'; // Display in hours
  }

  List<BarChartGroupData> _generateBarGroups(List<AppUsageData> data) {
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].getUsageInHours(),
            gradient: const LinearGradient(colors: [
              Color(0XFFA342FF),
              Color(0XFFE54D60),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  String _getDayLabel(int index) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index % 7];
  }

  int _getTotalWeeks() {
    final earliestDate = widget.allAppUsageData.first.createdAt;
    final latestDate = widget.allAppUsageData.last.createdAt;
    return (latestDate.difference(earliestDate).inDays / 7).ceil();
  }

  List<AppUsageData> _getWeeklyDataForPage(int pageIndex) {
    final DateTime startOfWeek =
        DateTime.now().subtract(Duration(days: (pageIndex * 7)));
    final DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    return widget.allAppUsageData.where((data) {
      return data.createdAt.isAfter(startOfWeek) &&
          data.createdAt.isBefore(endOfWeek);
    }).toList();
  }

  double _getMaxUsage(List<AppUsageData> weeklyData) {
    if (weeklyData.isEmpty) return 0;
    return weeklyData
        .map((data) => data.getUsageInHours())
        .reduce((a, b) => a > b ? a : b);
  }
}
