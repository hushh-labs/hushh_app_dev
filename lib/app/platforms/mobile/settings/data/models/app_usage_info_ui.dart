class AppUsageInfo {
  final String iconPath;
  final String name;
  final String time;
  final String appId;
  final String? categoryName;
  final bool? canConnect;

  AppUsageInfo({
    required this.iconPath,
    required this.name,
    required this.time,
    required this.appId,
    this.categoryName,
    this.canConnect,
  });
}