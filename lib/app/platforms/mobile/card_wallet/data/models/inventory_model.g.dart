// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryModel _$InventoryModelFromJson(Map<String, dynamic> json) =>
    InventoryModel(
      InventoryConfiguration.fromJson(
          json['configuration'] as Map<String, dynamic>),
      InventoryModel._fromInventoryJsonList(json['products'] as List),
    );

Map<String, dynamic> _$InventoryModelToJson(InventoryModel instance) =>
    <String, dynamic>{
      'configuration': instance.configuration,
      'products': instance.products,
    };
