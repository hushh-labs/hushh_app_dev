// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browsed_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrowsedProduct _$BrowsedProductFromJson(Map<String, dynamic> json) =>
    BrowsedProduct(
      userId: json['user_id'] as String?,
      productUrl: json['product_url'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      productTitle: json['product_title'] as String?,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
      productPageUrl: json['product_page_url'] as String?,
      brand: json['brand'] == null
          ? null
          : Brand.fromJson(json['brand'] as Map<String, dynamic>),
      productCategory: json['product_category'] as String?,
      price: BrowsedProduct._priceFromJson(json['price']),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$BrowsedProductToJson(BrowsedProduct instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'product_url': instance.productUrl,
      'product_title': instance.productTitle,
      'image_url': instance.imageUrl,
      'description': instance.description,
      'product_page_url': instance.productPageUrl,
      'brand': BrowsedProduct._brandNameToJson(instance.brand),
      'product_category': instance.productCategory,
      'price': instance.price,
      'currency': instance.currency,
      'timestamp': instance.timestamp.toIso8601String(),
    };
