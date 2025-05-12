// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchased_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchasedItem _$PurchasedItemFromJson(Map<String, dynamic> json) =>
    PurchasedItem(
      brandCategory: json['brand_category'] as String,
      category: json['category'] as String,
      subCategories: (json['sub_categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
    );

Map<String, dynamic> _$PurchasedItemToJson(PurchasedItem instance) =>
    <String, dynamic>{
      'brand_category': instance.brandCategory,
      'category': instance.category,
      'sub_categories': instance.subCategories,
      'total_amount': instance.totalAmount,
    };
