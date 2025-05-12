import 'dart:convert';

import 'package:health/health.dart';

class HealthInfoModel {
  String? dateFrom;
  String? dateTo;
  String? timeZoneName;
  String? timeZoneOffset;
  dynamic deviceInfo;
  List<HealthDataPoint>? data;

  HealthInfoModel(
      {this.dateFrom,
      this.dateTo,
      this.timeZoneName,
      this.timeZoneOffset,
      this.deviceInfo,
      this.data});

  HealthInfoModel.fromJson(Map<String, dynamic> json) {
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    timeZoneName = json['time_zone_name'];
    timeZoneOffset = json['time_zone_offset'];
    deviceInfo = json['device_info'];
    if (json['data'] != null) {
      data = <HealthDataPoint>[];
      json['data'].forEach((v) {
        data!.add(HealthDataPoint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['time_zone_name'] = this.timeZoneName;
    data['time_zone_offset'] = this.timeZoneOffset;
    data['device_info'] = this.deviceInfo;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Value {
  String? numericValue;

  Value({this.numericValue});

  Value.fromJson(Map<String, dynamic> json) {
    numericValue = json['numericValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numericValue'] = this.numericValue;
    return data;
  }
}

DeviceInfo deviceInfoFromJson(String str) =>
    DeviceInfo.fromJson(json.decode(str));

String deviceInfoToJson(DeviceInfo data) => json.encode(data.toJson());

class DeviceInfo {
  DeviceInfo({
    required this.version,
    required this.model,
    required this.brand,
    required this.device,
  });

  final String version;
  final String model;
  final String brand;
  final String device;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
        version: json["version"],
        model: json["model"],
        brand: json["brand"],
        device: json["device"],
      );

  Map<String, dynamic> toJson() =>
      {"version": version, "brand": "${brand}_$model"};
}

DeviceInfoIos deviceInfoFromJsonIos(String str) =>
    DeviceInfoIos.fromJson(json.decode(str));

String deviceInfoToJsonIos(DeviceInfoIos data) => json.encode(data.toJson());

class DeviceInfoIos {
  DeviceInfoIos({
    required this.name,
    required this.systemVersion,
  });

  final String name;
  final String systemVersion;

  factory DeviceInfoIos.fromJson(Map<String, dynamic> json) => DeviceInfoIos(
        name: json["name"],
        systemVersion: json["systemVersion"],
      );

  Map<String, dynamic> toJson() =>
      {"name": name, "systemVersion": systemVersion};
}
