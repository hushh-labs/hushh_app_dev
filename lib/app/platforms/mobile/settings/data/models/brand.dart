import 'package:json_annotation/json_annotation.dart';

part 'brand.g.dart';

@JsonSerializable()
class Brand {
  @JsonKey(name: 'brand_name')
  final String brandName;

  @JsonKey(name: 'brand_category')
  final String? brandCategory;

  @JsonKey(name: 'brand_segment')
  final String? brandSegment;

  Brand({
    required this.brandName,
    this.brandCategory,
    this.brandSegment,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}
