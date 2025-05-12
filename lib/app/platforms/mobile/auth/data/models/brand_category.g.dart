// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandCategory _$BrandCategoryFromJson(Map<String, dynamic> json) =>
    BrandCategory(
      (json['id'] as num).toInt(),
      json['brand_category'] as String,
    );

Map<String, dynamic> _$BrandCategoryToJson(BrandCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brand_category': instance.brandCategory,
    };
