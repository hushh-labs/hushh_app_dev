// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_card_insights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelCardInsights _$TravelCardInsightsFromJson(Map<String, dynamic> json) =>
    TravelCardInsights(
      travelHistory: (json['travel_history'] as List<dynamic>)
          .map((e) => TravelHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      arrivalLocationFrequency:
          Map<String, int>.from(json['arrival_location_frequency'] as Map),
    );

Map<String, dynamic> _$TravelCardInsightsToJson(TravelCardInsights instance) =>
    <String, dynamic>{
      'travel_history': instance.travelHistory,
      'arrival_location_frequency': instance.arrivalLocationFrequency,
    };

TravelHistory _$TravelHistoryFromJson(Map<String, dynamic> json) =>
    TravelHistory(
      messageId: json['message_id'] as String,
      domain: json['domain'] as String?,
      logo: json['logo'] as String?,
      arrivalDate: json['arrival_date'] as String?,
      travelType: $enumDecode(_$TravelTypeEnumMap, json['travel_type']),
      departureDestination: json['departure_destination'] as String?,
      arrivalDestination: json['arrival_destination'] as String?,
    );

Map<String, dynamic> _$TravelHistoryToJson(TravelHistory instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'domain': instance.domain,
      'logo': instance.logo,
      'arrival_date': instance.arrivalDate,
      'travel_type': _$TravelTypeEnumMap[instance.travelType]!,
      'departure_destination': instance.departureDestination,
      'arrival_destination': instance.arrivalDestination,
    };

const _$TravelTypeEnumMap = {
  TravelType.bus: 'bus',
  TravelType.train: 'train',
  TravelType.airplane: 'airplane',
  TravelType.taxi: 'taxi',
  TravelType.bike: 'bike',
  TravelType.rickshaw: 'rickshaw',
};
