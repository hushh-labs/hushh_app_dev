// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CachedInventoryModel _$CachedInventoryModelFromJson(
        Map<String, dynamic> json) =>
    CachedInventoryModel(
      (json['total_count'] as num).toInt(),
      CachedInventoryModel._fromCachedInventoryJsonList(
          json['products'] as List),
    );

Map<String, dynamic> _$CachedInventoryModelToJson(
        CachedInventoryModel instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'products': instance.products,
    };
