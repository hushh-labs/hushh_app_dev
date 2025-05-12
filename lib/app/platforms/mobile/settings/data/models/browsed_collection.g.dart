// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browsed_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrowsedCollection _$BrowsedCollectionFromJson(Map<String, dynamic> json) =>
    BrowsedCollection(
      json['collection_name'] as String,
      (json['products'] as List<dynamic>)
          .map((e) => BrowsedProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['collection_id'] as String,
    );

Map<String, dynamic> _$BrowsedCollectionToJson(BrowsedCollection instance) =>
    <String, dynamic>{
      'collection_name': instance.name,
      'collection_id': instance.collectionId,
      'products': instance.products,
    };
