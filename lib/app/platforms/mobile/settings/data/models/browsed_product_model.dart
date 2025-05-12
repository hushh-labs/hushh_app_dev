import 'package:hushh_app/app/platforms/mobile/settings/data/models/brand.dart';
import 'package:json_annotation/json_annotation.dart';

part 'browsed_product_model.g.dart';

@JsonSerializable()
class BrowsedProduct {
  @JsonKey(name: 'user_id')
  final String? userId;

  @JsonKey(name: 'product_url')
  final String productUrl;

  @JsonKey(name: 'product_title')
  final String? productTitle;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'product_page_url')
  final String? productPageUrl;

  @JsonKey(name: 'brand', toJson: _brandNameToJson)
  final Brand? brand;

  @JsonKey(name: 'product_category')
  final String? productCategory;

  @JsonKey(fromJson: _priceFromJson)
  final String? price;

  final String? currency;

  final DateTime timestamp;

  BrowsedProduct({
    this.userId,
    required this.productUrl,
    required this.timestamp,
    this.productTitle,
    this.imageUrl,
    this.description,
    this.productPageUrl,
    this.brand,
    this.productCategory,
    this.price,
    this.currency,
  });

  factory BrowsedProduct.fromJson(Map<String, dynamic> json) =>
      _$BrowsedProductFromJson(json);

  Map<String, dynamic> toJson() => _$BrowsedProductToJson(this);

  static String? _priceFromJson(dynamic price) => price?.toString();

  static String? _brandNameToJson(Brand? brand) => brand?.brandName;
}
