import 'package:json_annotation/json_annotation.dart';
part 'covered_item.g.dart';

@JsonSerializable()
class CoveredItem {
  @JsonKey(name: 'item_type')
  final String? itemType;

  @JsonKey(name: 'product_company')
  final String? productCompany;

  @JsonKey(name: 'product_model')
  final String? productModel;

  @JsonKey(name: 'product_manufacturing_year')
  final String? productManufacturingYear;

  CoveredItem({
    this.itemType,
    this.productCompany,
    this.productModel,
    this.productManufacturingYear,
  });

  factory CoveredItem.fromJson(Map<String, dynamic> json) =>
      _$CoveredItemFromJson(json);

  Map<String, dynamic> toJson() => _$CoveredItemToJson(this);
}
