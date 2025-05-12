import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cached_inventory_model.g.dart';

@JsonSerializable()
class CachedInventoryModel {
  @JsonKey(name: 'total_count')
  final int totalCount;

  @JsonKey(fromJson: _fromCachedInventoryJsonList)
  final List<AgentProductModel> products;

  CachedInventoryModel(this.totalCount, this.products);

  factory CachedInventoryModel.fromJson(Map<String, dynamic> json) =>
      _$CachedInventoryModelFromJson(json);

  static List<AgentProductModel> _fromCachedInventoryJsonList(
          List<dynamic> jsonList) =>
      jsonList
          .map((json) => AgentProductModel.fromCachedInventoryJson(json))
          .toList();

  Map<String, dynamic> toJson() => _$CachedInventoryModelToJson(this);
}
