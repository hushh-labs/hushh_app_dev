// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseCategory _$PurchaseCategoryFromJson(Map<String, dynamic> json) =>
    PurchaseCategory(
      repeatCount: (json['repeatCount'] as num).toInt(),
      categoryName: json['categoryName'] as String,
    );

Map<String, dynamic> _$PurchaseCategoryToJson(PurchaseCategory instance) =>
    <String, dynamic>{
      'repeatCount': instance.repeatCount,
      'categoryName': instance.categoryName,
    };

CompetitorReceipt _$CompetitorReceiptFromJson(Map<String, dynamic> json) =>
    CompetitorReceipt(
      brandName: json['brandName'] as String,
      repeatCount: (json['repeatCount'] as num).toInt(),
    );

Map<String, dynamic> _$CompetitorReceiptToJson(CompetitorReceipt instance) =>
    <String, dynamic>{
      'brandName': instance.brandName,
      'repeatCount': instance.repeatCount,
    };

ShoppingDate _$ShoppingDateFromJson(Map<String, dynamic> json) => ShoppingDate(
      date: DateTime.parse(json['date'] as String),
      brandName: json['brandName'] as String,
    );

Map<String, dynamic> _$ShoppingDateToJson(ShoppingDate instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'brandName': instance.brandName,
    };

ReceiptInsights _$ReceiptInsightsFromJson(Map<String, dynamic> json) =>
    ReceiptInsights(
      purchaseCategories:
          (json['purchaseCategories'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      competitorReceipts:
          (json['competitorReceipts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      shoppingDates: (json['shoppingDates'] as List<dynamic>?)
          ?.map((e) => ShoppingDate.fromJson(e as Map<String, dynamic>))
          .toList(),
      hushhId: json['hushhId'] as String?,
      spendingCapacity: (json['spendingCapacity'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ReceiptInsightsToJson(ReceiptInsights instance) =>
    <String, dynamic>{
      'purchaseCategories': instance.purchaseCategories,
      'competitorReceipts': instance.competitorReceipts,
      'shoppingDates': instance.shoppingDates,
      'spendingCapacity': instance.spendingCapacity,
      'hushhId': instance.hushhId,
    };
