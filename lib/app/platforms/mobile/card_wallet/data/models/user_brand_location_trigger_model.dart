import 'package:json_annotation/json_annotation.dart';

part 'user_brand_location_trigger_model.g.dart';

@JsonSerializable()
class UserBrandLocationTriggerModel {
  @JsonKey(name: 'trigger_type')
  final String triggerType;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'brand_id')
  final int brandId;

  @JsonKey(name: 'brand_location_id')
  final int brandLocationId;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  UserBrandLocationTriggerModel({
    required this.triggerType,
    required this.userId,
    required this.brandId,
    required this.brandLocationId,
    this.createdAt,
  });

  factory UserBrandLocationTriggerModel.fromJson(Map<String, dynamic> json) =>
      _$UserBrandLocationTriggerModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserBrandLocationTriggerModelToJson(this);
}
