import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand_category.g.dart';

@JsonSerializable()
class BrandCategory extends Equatable {
  final int id;

  @JsonKey(name: 'brand_category')
  final String brandCategory;

  factory BrandCategory.fromJson(Map<String, dynamic> json) =>
      _$BrandCategoryFromJson(json);

  const BrandCategory(this.id, this.brandCategory);

  Map<String, dynamic> toJson() => _$BrandCategoryToJson(this);

  @override
  List<Object?> get props => [id, brandCategory];
}
