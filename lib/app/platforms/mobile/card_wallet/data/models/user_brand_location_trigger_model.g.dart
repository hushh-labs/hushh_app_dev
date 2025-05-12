// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_brand_location_trigger_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBrandLocationTriggerModel _$UserBrandLocationTriggerModelFromJson(
        Map<String, dynamic> json) =>
    UserBrandLocationTriggerModel(
      triggerType: json['trigger_type'] as String,
      userId: json['user_id'] as String,
      brandId: (json['brand_id'] as num).toInt(),
      brandLocationId: (json['brand_location_id'] as num).toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$UserBrandLocationTriggerModelToJson(
        UserBrandLocationTriggerModel instance) =>
    <String, dynamic>{
      'trigger_type': instance.triggerType,
      'user_id': instance.userId,
      'brand_id': instance.brandId,
      'brand_location_id': instance.brandLocationId,
      'created_at': instance.createdAt?.toIso8601String(),
    };
