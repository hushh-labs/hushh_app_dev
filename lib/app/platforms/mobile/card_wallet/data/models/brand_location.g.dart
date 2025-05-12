// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandLocation _$BrandLocationFromJson(Map<String, dynamic> json) =>
    BrandLocation(
      locationId: (json['location_id'] as num?)?.toInt(),
      brandName: json['brand_name'] as String?,
      brandId: (json['brand_id'] as num).toInt(),
      registeredBy: json['registered_by'] as String?,
      location: json['location'],
    );

Map<String, dynamic> _$BrandLocationToJson(BrandLocation instance) =>
    <String, dynamic>{
      'location_id': instance.locationId,
      'brand_id': instance.brandId,
      'brand_name': instance.brandName,
      'registered_by': instance.registeredBy,
      'location': instance.location,
    };
