import 'package:json_annotation/json_annotation.dart';

part 'inventory_configuration.g.dart';

@JsonSerializable()
class InventoryConfiguration {
  @JsonKey(name: 'configuration_id')
  final int configurationId;
  @JsonKey(name: 'inventory_name')
  final String inventoryName;
  @JsonKey(name: 'brand_id')
  final int brandId;

  @JsonKey(name: 'product_image_identifier')
  final String productImageIdentifier;
  @JsonKey(name: 'product_name_identifier')
  final String productNameIdentifier;
  @JsonKey(name: 'product_sku_unique_id_identifier')
  final String productSkuUniqueIdIdentifier;
  @JsonKey(name: 'product_price_identifier')
  final String productPriceIdentifier;
  @JsonKey(name: 'product_currency_identifier')
  final String productCurrencyIdentifier;
  @JsonKey(name: 'product_description_identifier')
  final String productDescriptionIdentifier;

  InventoryConfiguration(
      this.configurationId,
      this.productImageIdentifier,
      this.productNameIdentifier,
      this.productSkuUniqueIdIdentifier,
      this.productPriceIdentifier,
      this.productCurrencyIdentifier,
      this.productDescriptionIdentifier,
      this.inventoryName,
      this.brandId);

  factory InventoryConfiguration.fromJson(Map<String, dynamic> json) =>
      _$InventoryConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryConfigurationToJson(this);
}
