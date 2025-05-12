import 'package:json_annotation/json_annotation.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';

part 'browsed_collection.g.dart';

@JsonSerializable()
class BrowsedCollection {
  @JsonKey(name: 'collection_name')
  final String name;

  @JsonKey(name: 'collection_id')
  final String collectionId;

  @JsonKey(name: 'products')
  final List<BrowsedProduct> products;

  BrowsedCollection(this.name, this.products, this.collectionId);

  factory BrowsedCollection.fromJson(Map<String, dynamic> json) => _$BrowsedCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$BrowsedCollectionToJson(this);
}