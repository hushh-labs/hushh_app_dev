// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryConfiguration _$InventoryConfigurationFromJson(
        Map<String, dynamic> json) =>
    InventoryConfiguration(
      (json['configuration_id'] as num).toInt(),
      json['product_image_identifier'] as String,
      json['product_name_identifier'] as String,
      json['product_sku_unique_id_identifier'] as String,
      json['product_price_identifier'] as String,
      json['product_currency_identifier'] as String,
      json['product_description_identifier'] as String,
      json['inventory_name'] as String,
      (json['brand_id'] as num).toInt(),
    );

Map<String, dynamic> _$InventoryConfigurationToJson(
        InventoryConfiguration instance) =>
    <String, dynamic>{
      'configuration_id': instance.configurationId,
      'inventory_name': instance.inventoryName,
      'brand_id': instance.brandId,
      'product_image_identifier': instance.productImageIdentifier,
      'product_name_identifier': instance.productNameIdentifier,
      'product_sku_unique_id_identifier': instance.productSkuUniqueIdIdentifier,
      'product_price_identifier': instance.productPriceIdentifier,
      'product_currency_identifier': instance.productCurrencyIdentifier,
      'product_description_identifier': instance.productDescriptionIdentifier,
    };
