import 'package:hive_flutter/hive_flutter.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agent.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class AgentModel {
  @HiveField(1)
  @JsonKey(name: 'agent_work_email')
  final String? agentWorkEmail;

  @HiveField(2)
  @JsonKey(name: 'agent_approval_status')
  final AgentApprovalStatus? agentApprovalStatus;

  @HiveField(3)
  @JsonKey(name: 'agent_conversations')
  List<String>? agentConversations;

  @HiveField(4)
  @JsonKey(name: 'agent_name')
  final String? agentName;

  @HiveField(5)
  @JsonKey(name: 'agent_brand_id')
  final int agentBrandId;

  @HiveField(6)
  @JsonKey(name: 'agent_card')
  final CardModel? agentCard;

  @HiveField(7)
  @JsonKey(name: 'agent_desc')
  final String? agentDesc;

  @HiveField(8)
  @JsonKey(name: 'agent_image')
  final String? agentImage;

  @HiveField(9)
  @JsonKey(name: 'agent_coins')
  final int? agentCoins;

  @HiveField(10)
  @JsonKey(name: 'agent_categories')
  final List<AgentCategory>? agentCategories;

  @HiveField(11)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(12)
  @JsonKey(name: 'hushh_id')
  final String? hushhId;

  @HiveField(13)
  @JsonKey(name: 'agent_recent_lat')
  final double? agentRecentLat; // from view

  @HiveField(14)
  @JsonKey(name: 'agent_recent_long')
  final double? agentRecentLong; // from view

  @HiveField(15)
  @JsonKey(name: 'agent_brand')
  final Brand? agentBrand; // from view

  @HiveField(16)
  @JsonKey(name: 'agent_role')
  final AgentRole? role; // from view

  AgentModel(
      {this.agentWorkEmail,
      this.agentApprovalStatus,
      this.agentName,
      this.agentDesc,
      this.agentImage,
      this.agentCoins,
      this.agentCategories,
      this.hushhId,
      this.agentConversations,
      required this.agentBrandId,
      this.agentCard,
      this.agentBrand,
      this.agentRecentLat,
      this.agentRecentLong,
      this.role,
      this.createdAt});

  factory AgentModel.fromJson(Map<String, dynamic> json) =>
      _$AgentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AgentModelToJson(this);

  AgentModel copyWith(
      {String? agentWorkEmail,
    AgentApprovalStatus? agentApprovalStatus,
    List<String>? agentConversations,
    String? agentName,
    String? agentDesc,
    String? agentImage,
    int? agentCoins,
    List<AgentCategory>? agentCategories,
    String? hushhId,
    double? agentRecentLat,
    double? agentRecentLong,
    Brand? agentBrand,
    AgentRole? role,
    int? agentBrandId,
    CardModel? agentCard,
    DateTime? createdAt,
  }) {
    return AgentModel(
      agentWorkEmail: agentWorkEmail ?? this.agentWorkEmail,
      agentApprovalStatus: agentApprovalStatus ?? this.agentApprovalStatus,
      agentConversations: agentConversations ?? this.agentConversations,
      agentName: agentName ?? this.agentName,
      agentDesc: agentDesc ?? this.agentDesc,
      agentImage: agentImage ?? this.agentImage,
      agentCoins: agentCoins ?? this.agentCoins,
      agentCategories: agentCategories ?? this.agentCategories,
      hushhId: hushhId ?? this.hushhId,
      agentRecentLat: agentRecentLat ?? this.agentRecentLat,
      agentRecentLong: agentRecentLong ?? this.agentRecentLong,
      agentBrand: agentBrand ?? this.agentBrand,
      role: role ?? this.role,
      agentBrandId: agentBrandId ?? this.agentBrandId,
      agentCard: agentCard ?? this.agentCard,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
