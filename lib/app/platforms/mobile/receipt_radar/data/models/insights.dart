import 'package:json_annotation/json_annotation.dart';

part 'insights.g.dart';

@JsonSerializable()
class PurchaseCategory {
  final int repeatCount;
  final String categoryName;

  PurchaseCategory({required this.repeatCount, required this.categoryName});

  factory PurchaseCategory.fromJson(Map<String, dynamic> json) =>
      _$PurchaseCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseCategoryToJson(this);
}

@JsonSerializable()
class CompetitorReceipt {
  final String brandName;
  final int repeatCount;

  CompetitorReceipt({required this.brandName, required this.repeatCount});

  factory CompetitorReceipt.fromJson(Map<String, dynamic> json) =>
      _$CompetitorReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$CompetitorReceiptToJson(this);
}

@JsonSerializable()
class ShoppingDate {
  final DateTime date;
  final String brandName;

  ShoppingDate({required this.date, required this.brandName});

  factory ShoppingDate.fromJson(Map<String, dynamic> json) =>
      _$ShoppingDateFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingDateToJson(this);
}

@JsonSerializable()
class ReceiptInsights {
  final Map<String, int> purchaseCategories;
  final Map<String, int> competitorReceipts;
  final List<ShoppingDate> shoppingDates;
  final double spendingCapacity;
  final String? hushhId;

  ReceiptInsights({
    Map<String, int>? purchaseCategories,
    Map<String, int>? competitorReceipts,
    List<ShoppingDate>? shoppingDates,
    this.hushhId,
    this.spendingCapacity = 0,
  })  : purchaseCategories = purchaseCategories ?? {},
        competitorReceipts = competitorReceipts ?? {},
        shoppingDates = shoppingDates ?? [];

  factory ReceiptInsights.fromJson(Map<String, dynamic> json) =>
      _$ReceiptInsightsFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptInsightsToJson(this);

  ReceiptInsights copyWith({
    Map<String, int>? purchaseCategories,
    Map<String, int>? competitorReceipts,
    List<ShoppingDate>? shoppingDates,
    double? spendingCapacity,
    String? userId,
  }) {
    return ReceiptInsights(
      hushhId: userId ?? this.hushhId,
      purchaseCategories: purchaseCategories ?? this.purchaseCategories,
      competitorReceipts: competitorReceipts ?? this.competitorReceipts,
      shoppingDates: shoppingDates ?? this.shoppingDates,
      spendingCapacity: spendingCapacity ?? this.spendingCapacity,
    );
  }
}
