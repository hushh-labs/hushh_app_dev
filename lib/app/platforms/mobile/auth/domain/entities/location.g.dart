// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      id: (json['id'] as num?)?.toInt(),
      hushhId: json['hushh_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      location: json['location'] as String,
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hushh_id': instance.hushhId,
      'created_at': instance.createdAt.toIso8601String(),
      'location': instance.location,
    };
