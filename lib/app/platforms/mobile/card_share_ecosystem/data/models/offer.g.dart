// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
      id: (json['id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      offerDesc: json['offer_desc'] as String,
      discountTag: json['discount_tag'] as String,
      brandId: (json['brand_id'] as num).toInt(),
      brandInventoryViewName: json['brand_inventory_view_name'] as String,
      productSku: (json['product_sku'] as num).toInt(),
      updatedPrice: (json['updated_price'] as num).toInt(),
      isHighlighted: json['is_highlighted'] as bool,
      product:
          Offer._productFromJson(json['product_info'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'offer_desc': instance.offerDesc,
      'discount_tag': instance.discountTag,
      'brand_id': instance.brandId,
      'brand_inventory_view_name': instance.brandInventoryViewName,
      'product_sku': instance.productSku,
      'updated_price': instance.updatedPrice,
      'is_highlighted': instance.isHighlighted,
      'product_info': instance.product,
    };
