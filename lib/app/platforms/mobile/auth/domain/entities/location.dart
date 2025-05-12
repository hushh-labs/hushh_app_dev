import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class LocationModel {
  final int? id;

  @JsonKey(name: 'hushh_id')
  final String hushhId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  final String location;

  LocationModel(
      {this.id,
      required this.hushhId,
      required this.createdAt,
      required this.location});

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
