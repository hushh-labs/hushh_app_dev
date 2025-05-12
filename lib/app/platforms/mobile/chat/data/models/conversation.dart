import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tuple/tuple.dart';

part 'conversation.g.dart';

@JsonSerializable()
class Conversation {
  final Map<String, dynamic> participants;
  final Message? lastMessage;
  final DateTime lastUpdated;
  final String id;
  final ConversationType type;
  int unreadCount;

  Conversation({
    required this.participants,
    required this.lastMessage,
    required this.lastUpdated,
    required this.id,
    required this.type,
    this.unreadCount = 0,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  dynamic getOtherUserInfo(key) {
    for (var uid in participants.keys) {
      if (uid != AppLocalStorage.hushhId) {
        return participants[uid][key]?.trim().isNotEmpty ?? false
            ? participants[uid][key]
            : null;
      }
    }
    return null;
  }

  CardModel? getOtherUserBrand() {
    for (var uid in participants.keys) {
      if (uid != AppLocalStorage.hushhId) {
        return participants[uid]['brand'] != null
            ? CardModel.fromJson(participants[uid]['brand'])
            : null;
      }
    }
    return null;
  }

  Tuple2<Map, String>? getOtherUser() {
    for (var uid in participants.keys) {
      if (uid != AppLocalStorage.hushhId) {
        return Tuple2(participants[uid], uid);
      }
    }
    return null;
  }

  Conversation copyWith({
    Map<String, dynamic>? participants,
    Message? lastMessage,
    DateTime? lastUpdated,
    String? id,
    ConversationType? type,
    int? unreadCount,
  }) {
    return Conversation(
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      id: id ?? this.id,
      type: type ?? this.type,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

}
