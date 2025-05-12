import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable()
class Offer {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'offer_desc')
  final String offerDesc;

  @JsonKey(name: 'discount_tag')
  final String discountTag;

  @JsonKey(name: 'brand_id')
  final int brandId;

  @JsonKey(name: 'brand_inventory_view_name')
  final String brandInventoryViewName;

  @JsonKey(name: 'product_sku')
  final int productSku;

  @JsonKey(name: 'updated_price')
  final int updatedPrice;

  @JsonKey(name: 'is_highlighted')
  final bool isHighlighted;

  @JsonKey(name: 'product_info', fromJson: _productFromJson)
  final AgentProductModel? product;

  Offer({
    required this.id,
    required this.createdAt,
    required this.offerDesc,
    required this.discountTag,
    required this.brandId,
    required this.brandInventoryViewName,
    required this.productSku,
    required this.updatedPrice,
    required this.isHighlighted,
    this.product
  });

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);

  static AgentProductModel? _productFromJson(Map<String, dynamic>? data) {
    if(data == null) return null;
    return AgentProductModel.fromCachedInventoryJson(data);
  }
}
