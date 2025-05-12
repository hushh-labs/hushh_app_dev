// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      participants: json['participants'] as Map<String, dynamic>,
      lastMessage: json['lastMessage'] == null
          ? null
          : Message.fromJson(json['lastMessage'] as Map<String, dynamic>),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      id: json['id'] as String,
      type: $enumDecode(_$ConversationTypeEnumMap, json['type']),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'id': instance.id,
      'type': _$ConversationTypeEnumMap[instance.type]!,
      'unreadCount': instance.unreadCount,
    };

const _$ConversationTypeEnumMap = {
  ConversationType.agent: 'agent',
  ConversationType.user: 'user',
};
