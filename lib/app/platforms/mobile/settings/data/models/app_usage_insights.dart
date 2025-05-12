class AppUsageInsights {
  final int appCategoryId;
  final String categoryName;
  final int totalTimeSpent;
  final double percentChangeByDay;
  final double percentChangeByWeek;
  final double percentChangeByMonth;
  final List<AppInfo> apps;

  AppUsageInsights({
    required this.appCategoryId,
    required this.categoryName,
    required this.totalTimeSpent,
    required this.percentChangeByDay,
    required this.percentChangeByWeek,
    required this.percentChangeByMonth,
    required this.apps,
  });

  // Factory constructor to create an instance from a JSON map
  factory AppUsageInsights.fromJson(Map<String, dynamic> json) {
    return AppUsageInsights(
      appCategoryId: json['category_id'],
      categoryName: json['category_name'],
      totalTimeSpent: json['total_usage'],
      percentChangeByDay: json['percent_change_by_day']?.toDouble() ?? 0,
      percentChangeByWeek: json['percent_change_by_week']?.toDouble() ?? 0,
      percentChangeByMonth: json['percent_change_by_month']?.toDouble() ?? 0,
      apps: (json['apps'] as List<dynamic>?)
          ?.map((appJson) => AppInfo.fromJson(appJson))
          .toList() ?? [],
    );
  }

  // Method to convert the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'category_id': appCategoryId,
      'category_name': categoryName,
      'total_usage': totalTimeSpent,
      'percent_change_by_day': percentChangeByDay,
      'percent_change_by_week': percentChangeByWeek,
      'percent_change_by_month': percentChangeByMonth,
      'apps': apps.map((app) => app.toJson()).toList(),
    };
  }
}

class AppInfo {
  final String appId;
  final String iconUrl;
  final String appName;

  AppInfo({
    required this.appId,
    required this.iconUrl,
    required this.appName,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      appId: json['app_id'],
      appName: json['app_name']?.split(':').first ?? 'Unavailable',
      iconUrl: json['icon_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_id': appId,
      'icon_url': iconUrl,
    };
  }
}