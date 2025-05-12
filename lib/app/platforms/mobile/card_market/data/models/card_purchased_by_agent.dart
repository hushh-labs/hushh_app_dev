import 'package:json_annotation/json_annotation.dart';

part 'card_purchased_by_agent.g.dart';

@JsonSerializable()
class CardPurchasedByAgent {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'shared_id')
  final int? sharedId;

  @JsonKey(name: 'card_id')
  final int cardId;

  @JsonKey(name: 'agent_id')
  final String agentId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  CardPurchasedByAgent({
    this.id,
    this.sharedId,
    required this.cardId,
    required this.agentId,
    required this.createdAt,
  });

  factory CardPurchasedByAgent.fromJson(Map<String, dynamic> json) =>
      _$CardPurchasedByAgentFromJson(json);

  Map<String, dynamic> toJson() => _$CardPurchasedByAgentToJson(this);

  CardPurchasedByAgent copyWith({
    int? id,
    int? sharedId,
    int? cardId,
    String? agentId,
    DateTime? createdAt,
  }) {
    return CardPurchasedByAgent(
      id: id ?? this.id,
      sharedId: sharedId ?? this.sharedId,
      cardId: cardId ?? this.cardId,
      agentId: agentId ?? this.agentId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
