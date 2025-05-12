// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgentCategoryAdapter extends TypeAdapter<AgentCategory> {
  @override
  final int typeId = 5;

  @override
  AgentCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgentCategory(
      fields[0] as String,
      fields[1] as int,
      fields[2] as String,
      fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AgentCategory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentCategory _$AgentCategoryFromJson(Map<String, dynamic> json) =>
    AgentCategory(
      json['name'] as String,
      (json['id'] as num).toInt(),
      json['type'] as String,
      json['image'] as String?,
    );

Map<String, dynamic> _$AgentCategoryToJson(AgentCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'type': instance.type,
      'image': instance.image,
    };
