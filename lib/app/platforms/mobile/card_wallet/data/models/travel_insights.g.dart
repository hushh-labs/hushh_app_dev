// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_insights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelInsight _$TravelInsightFromJson(Map<String, dynamic> json) =>
    TravelInsight(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$TravelInsightToJson(TravelInsight instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
