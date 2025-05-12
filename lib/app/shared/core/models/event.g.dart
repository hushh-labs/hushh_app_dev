// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      agentUuid: json['agent_uuid'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'agent_uuid': instance.agentUuid,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'end_date': instance.endDate?.toIso8601String(),
    };
