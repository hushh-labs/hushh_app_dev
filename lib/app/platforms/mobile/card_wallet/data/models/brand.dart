import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand.g.dart';

@JsonSerializable()
@HiveType(typeId: 11)
class Brand extends Equatable {
  @HiveField(1)
  int? id;

  @HiveField(2)
  final String? domain;

  @JsonKey(name: 'brand_name')
  @HiveField(3)
  final String brandName;

  @JsonKey(name: 'brand_category_id')
  @HiveField(4)
  final int brandCategoryId;

  @JsonKey(name: 'brand_logo')
  @HiveField(5)
  final String brandLogo;

  @JsonKey(name: 'custom_brand')
  @HiveField(6)
  final bool customBrand;

  @JsonKey(name: 'is_claimed')
  @HiveField(7)
  final bool isClaimed;

  @JsonKey(name: 'brand_approval_status')
  @HiveField(8)
  final BrandApprovalStatus? brandApprovalStatus;

  @JsonKey(name: 'configurations')
  @HiveField(9)
  final List<int>? configurations;


  @JsonKey(name: 'agent_to_operate_for_brand_status')
  @HiveField(10)
  final AgentApprovalStatus? agentToOperateForBrandStatus;

  Brand({
    this.id,
    this.domain,
    required this.brandName,
    required this.brandCategoryId,
    required this.brandLogo,
    required this.customBrand,
    this.isClaimed = false,
    this.brandApprovalStatus,
    this.configurations,
    this.agentToOperateForBrandStatus
  });

  @override
  List<Object?> get props => [id, domain, brandName];

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}
