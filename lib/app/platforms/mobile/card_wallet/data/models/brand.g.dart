// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrandAdapter extends TypeAdapter<Brand> {
  @override
  final int typeId = 11;

  @override
  Brand read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Brand(
      id: fields[1] as int?,
      domain: fields[2] as String?,
      brandName: fields[3] as String,
      brandCategoryId: fields[4] as int,
      brandLogo: fields[5] as String,
      customBrand: fields[6] as bool,
      isClaimed: fields[7] as bool,
      brandApprovalStatus: fields[8] as BrandApprovalStatus?,
      configurations: (fields[9] as List?)?.cast<int>(),
      agentToOperateForBrandStatus: fields[10] as AgentApprovalStatus?,
    );
  }

  @override
  void write(BinaryWriter writer, Brand obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.domain)
      ..writeByte(3)
      ..write(obj.brandName)
      ..writeByte(4)
      ..write(obj.brandCategoryId)
      ..writeByte(5)
      ..write(obj.brandLogo)
      ..writeByte(6)
      ..write(obj.customBrand)
      ..writeByte(7)
      ..write(obj.isClaimed)
      ..writeByte(8)
      ..write(obj.brandApprovalStatus)
      ..writeByte(9)
      ..write(obj.configurations)
      ..writeByte(10)
      ..write(obj.agentToOperateForBrandStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
      id: (json['id'] as num?)?.toInt(),
      domain: json['domain'] as String?,
      brandName: json['brand_name'] as String,
      brandCategoryId: (json['brand_category_id'] as num).toInt(),
      brandLogo: json['brand_logo'] as String,
      customBrand: json['custom_brand'] as bool,
      isClaimed: json['is_claimed'] as bool? ?? false,
      brandApprovalStatus: $enumDecodeNullable(
          _$BrandApprovalStatusEnumMap, json['brand_approval_status']),
      configurations: (json['configurations'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      agentToOperateForBrandStatus: $enumDecodeNullable(
          _$AgentApprovalStatusEnumMap,
          json['agent_to_operate_for_brand_status']),
    );

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'id': instance.id,
      'domain': instance.domain,
      'brand_name': instance.brandName,
      'brand_category_id': instance.brandCategoryId,
      'brand_logo': instance.brandLogo,
      'custom_brand': instance.customBrand,
      'is_claimed': instance.isClaimed,
      'brand_approval_status':
          _$BrandApprovalStatusEnumMap[instance.brandApprovalStatus],
      'configurations': instance.configurations,
      'agent_to_operate_for_brand_status':
          _$AgentApprovalStatusEnumMap[instance.agentToOperateForBrandStatus],
    };

const _$BrandApprovalStatusEnumMap = {
  BrandApprovalStatus.approved: 'approved',
  BrandApprovalStatus.pending: 'pending',
  BrandApprovalStatus.denied: 'denied',
};

const _$AgentApprovalStatusEnumMap = {
  AgentApprovalStatus.approved: 'approved',
  AgentApprovalStatus.pending: 'pending',
  AgentApprovalStatus.denied: 'denied',
};
