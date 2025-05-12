// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_purchased_by_agent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardPurchasedByAgent _$CardPurchasedByAgentFromJson(
        Map<String, dynamic> json) =>
    CardPurchasedByAgent(
      id: (json['id'] as num?)?.toInt(),
      sharedId: (json['shared_id'] as num?)?.toInt(),
      cardId: (json['card_id'] as num).toInt(),
      agentId: json['agent_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CardPurchasedByAgentToJson(
        CardPurchasedByAgent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shared_id': instance.sharedId,
      'card_id': instance.cardId,
      'agent_id': instance.agentId,
      'created_at': instance.createdAt.toIso8601String(),
    };
