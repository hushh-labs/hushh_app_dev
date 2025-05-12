import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'purchased_item.g.dart';

@JsonSerializable(explicitToJson: true)
class PurchasedItem {
  @JsonKey(name: 'brand_category')
  final String brandCategory;
  @JsonKey(name: 'category')
  final String category;
  @JsonKey(name: 'sub_categories')
  final List<String> subCategories;
  @JsonKey(name: 'total_amount')
  final double totalAmount;

  PurchasedItem({
    required this.brandCategory,
    required this.category,
    required this.subCategories,
    required this.totalAmount,
  });

  /// Factory method to create a `PurchasedItem` instance from a JSON map.
  factory PurchasedItem.fromJson(Map<String, dynamic> json) =>
      _$PurchasedItemFromJson(json);

  /// Converts a `PurchasedItem` instance to a JSON map.
  Map<String, dynamic> toJson() => _$PurchasedItemToJson(this);

  /// Utility method to parse a list of JSON objects into a list of `PurchasedItem`.
  static List<PurchasedItem> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => PurchasedItem.fromJson(json)).toList();
  }

  /// Utility method to convert a list of `PurchasedItem` instances into a JSON string.
  static String toJsonList(List<PurchasedItem> items) {
    final List<Map<String, dynamic>> jsonList =
    items.map((item) => item.toJson()).toList();
    return json.encode(jsonList);
  }
}
