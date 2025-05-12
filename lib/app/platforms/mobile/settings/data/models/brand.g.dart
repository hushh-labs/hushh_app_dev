// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
      brandName: json['brand_name'] as String,
      brandCategory: json['brand_category'] as String?,
      brandSegment: json['brand_segment'] as String?,
    );

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'brand_name': instance.brandName,
      'brand_category': instance.brandCategory,
      'brand_segment': instance.brandSegment,
    };
