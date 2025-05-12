// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'covered_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoveredItem _$CoveredItemFromJson(Map<String, dynamic> json) => CoveredItem(
      itemType: json['item_type'] as String?,
      productCompany: json['product_company'] as String?,
      productModel: json['product_model'] as String?,
      productManufacturingYear: json['product_manufacturing_year'] as String?,
    );

Map<String, dynamic> _$CoveredItemToJson(CoveredItem instance) =>
    <String, dynamic>{
      'item_type': instance.itemType,
      'product_company': instance.productCompany,
      'product_model': instance.productModel,
      'product_manufacturing_year': instance.productManufacturingYear,
    };
