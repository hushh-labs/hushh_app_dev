import 'package:json_annotation/json_annotation.dart';

part 'travel_insights.g.dart';

@JsonSerializable()
class TravelInsight {
  final double latitude;
  final double longitude;

  TravelInsight(this.latitude, this.longitude);

  factory TravelInsight.fromJson(Map<String, dynamic> json) =>
      _$TravelInsightFromJson(json);

  Map<String, dynamic> toJson() => _$TravelInsightToJson(this);
}
