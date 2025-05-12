import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_configuration.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_model.g.dart';

@JsonSerializable()
class InventoryModel {
  final InventoryConfiguration configuration;

  @JsonKey(fromJson: _fromInventoryJsonList)
  final List<AgentProductModel> products;

  InventoryModel(this.configuration, this.products);

  factory InventoryModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelFromJson(json);

  static List<AgentProductModel> _fromInventoryJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => AgentProductModel.fromInventoryJson(json)).toList();


  Map<String, dynamic> toJson() => _$InventoryModelToJson(this);
}
