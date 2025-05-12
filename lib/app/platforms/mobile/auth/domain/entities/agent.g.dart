// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgentModelAdapter extends TypeAdapter<AgentModel> {
  @override
  final int typeId = 6;

  @override
  AgentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgentModel(
      agentWorkEmail: fields[1] as String?,
      agentApprovalStatus: fields[2] as AgentApprovalStatus?,
      agentName: fields[4] as String?,
      agentDesc: fields[7] as String?,
      agentImage: fields[8] as String?,
      agentCoins: fields[9] as int?,
      agentCategories: (fields[10] as List?)?.cast<AgentCategory>(),
      hushhId: fields[12] as String?,
      agentConversations: (fields[3] as List?)?.cast<String>(),
      agentBrandId: fields[5] as int,
      agentCard: fields[6] as CardModel?,
      agentBrand: fields[15] as Brand?,
      agentRecentLat: fields[13] as double?,
      agentRecentLong: fields[14] as double?,
      role: fields[16] as AgentRole?,
      createdAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AgentModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(1)
      ..write(obj.agentWorkEmail)
      ..writeByte(2)
      ..write(obj.agentApprovalStatus)
      ..writeByte(3)
      ..write(obj.agentConversations)
      ..writeByte(4)
      ..write(obj.agentName)
      ..writeByte(5)
      ..write(obj.agentBrandId)
      ..writeByte(6)
      ..write(obj.agentCard)
      ..writeByte(7)
      ..write(obj.agentDesc)
      ..writeByte(8)
      ..write(obj.agentImage)
      ..writeByte(9)
      ..write(obj.agentCoins)
      ..writeByte(10)
      ..write(obj.agentCategories)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.hushhId)
      ..writeByte(13)
      ..write(obj.agentRecentLat)
      ..writeByte(14)
      ..write(obj.agentRecentLong)
      ..writeByte(15)
      ..write(obj.agentBrand)
      ..writeByte(16)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentModel _$AgentModelFromJson(Map<String, dynamic> json) => AgentModel(
      agentWorkEmail: json['agent_work_email'] as String?,
      agentApprovalStatus: $enumDecodeNullable(
          _$AgentApprovalStatusEnumMap, json['agent_approval_status']),
      agentName: json['agent_name'] as String?,
      agentDesc: json['agent_desc'] as String?,
      agentImage: json['agent_image'] as String?,
      agentCoins: (json['agent_coins'] as num?)?.toInt(),
      agentCategories: (json['agent_categories'] as List<dynamic>?)
          ?.map((e) => AgentCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      hushhId: json['hushh_id'] as String?,
      agentConversations: (json['agent_conversations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      agentBrandId: (json['agent_brand_id'] as num).toInt(),
      agentCard: json['agent_card'] == null
          ? null
          : CardModel.fromJson(json['agent_card'] as Map<String, dynamic>),
      agentBrand: json['agent_brand'] == null
          ? null
          : Brand.fromJson(json['agent_brand'] as Map<String, dynamic>),
      agentRecentLat: (json['agent_recent_lat'] as num?)?.toDouble(),
      agentRecentLong: (json['agent_recent_long'] as num?)?.toDouble(),
      role: $enumDecodeNullable(_$AgentRoleEnumMap, json['agent_role']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AgentModelToJson(AgentModel instance) =>
    <String, dynamic>{
      'agent_work_email': instance.agentWorkEmail,
      'agent_approval_status':
          _$AgentApprovalStatusEnumMap[instance.agentApprovalStatus],
      'agent_conversations': instance.agentConversations,
      'agent_name': instance.agentName,
      'agent_brand_id': instance.agentBrandId,
      'agent_card': instance.agentCard,
      'agent_desc': instance.agentDesc,
      'agent_image': instance.agentImage,
      'agent_coins': instance.agentCoins,
      'agent_categories': instance.agentCategories,
      'created_at': instance.createdAt?.toIso8601String(),
      'hushh_id': instance.hushhId,
      'agent_recent_lat': instance.agentRecentLat,
      'agent_recent_long': instance.agentRecentLong,
      'agent_brand': instance.agentBrand,
      'agent_role': _$AgentRoleEnumMap[instance.role],
    };

const _$AgentApprovalStatusEnumMap = {
  AgentApprovalStatus.approved: 'approved',
  AgentApprovalStatus.pending: 'pending',
  AgentApprovalStatus.denied: 'denied',
};

const _$AgentRoleEnumMap = {
  AgentRole.Admin: 'Admin',
  AgentRole.Owner: 'Owner',
  AgentRole.InventoryManager: 'InventoryManager',
  AgentRole.SalesManager: 'SalesManager',
  AgentRole.ContentManager: 'ContentManager',
  AgentRole.SalesAgent: 'SalesAgent',
  AgentRole.Support: 'Support',
};
