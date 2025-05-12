import 'package:equatable/equatable.dart';

class AppUsageData extends Equatable {
  final int? appUsageId;
  final String hushhId;
  final DateTime createdAt;
  final DateTime startData;
  final DateTime endData;
  final String appId;
  final int usage;
  final DateTime lastForeground;

  AppUsageData({
    this.appUsageId,
    required this.hushhId,
    required this.createdAt,
    required this.startData,
    required this.endData,
    required this.appId,
    required this.usage,
    required this.lastForeground,
  });

  factory AppUsageData.fromJson(Map<String, dynamic> data) {
    return AppUsageData(
      appUsageId: data['app_usage_id'],
      hushhId: data['hushh_id'],
      createdAt: DateTime.parse(data['created_at']),
      startData: DateTime.parse(data['start_data']),
      endData: DateTime.parse(data['end_data']),
      appId: data['app_id'],
      usage: data['usage'],
      lastForeground: DateTime.parse(data['last_foreground']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hushh_id': hushhId,
      'created_at': createdAt.toIso8601String(),
      'start_data': startData.toIso8601String(),
      'end_data': endData.toIso8601String(),
      'app_id': appId,
      'usage': usage,
      'last_foreground': lastForeground.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      [hushhId, appId, startData, endData, usage, lastForeground];

  double getUsageInHours() {
    return usage / 3600;
  }
}

List<AppUsageData> removeDuplicates(List<AppUsageData> appUsages) {
  List<AppUsageData> data = appUsages.toSet().toList();
  List<String> exclusions = ['launcher', 'com.google.android.gms', 'com.android.settings'];

  data.removeWhere((element) =>
      exclusions.any((exclusion) => element.appId.contains(exclusion)));

  return data;
}
