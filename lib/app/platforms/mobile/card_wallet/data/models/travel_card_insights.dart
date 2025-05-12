import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'travel_card_insights.g.dart';

@JsonSerializable()
class TravelCardInsights {
  @JsonKey(name: 'travel_history')
  final List<TravelHistory> travelHistory;

  @JsonKey(name: 'arrival_location_frequency')
  final Map<String, int> arrivalLocationFrequency;

  TravelCardInsights({
    required this.travelHistory,
    required this.arrivalLocationFrequency,
  });

  factory TravelCardInsights.fromJson(Map<String, dynamic> json) =>
      _$TravelCardInsightsFromJson(json);

  Map<String, dynamic> toJson() => _$TravelCardInsightsToJson(this);
}

@JsonSerializable()
class TravelHistory {
  @JsonKey(name: 'message_id')
  final String messageId;

  @JsonKey(name: 'domain')
  final String? domain;

  @JsonKey(name: 'logo')
  final String? logo;

  @JsonKey(name: 'arrival_date')
  final String? arrivalDate;

  @JsonKey(name: 'travel_type')
  final TravelType travelType;

  @JsonKey(name: 'departure_destination')
  final String? departureDestination;

  @JsonKey(name: 'arrival_destination')
  final String? arrivalDestination;

  TravelHistory({
    required this.messageId,
    this.domain,
    this.logo,
    this.arrivalDate,
    required this.travelType,
    this.departureDestination,
    this.arrivalDestination,
  });

  factory TravelHistory.fromJson(Map<String, dynamic> json) =>
      _$TravelHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$TravelHistoryToJson(this);
}
