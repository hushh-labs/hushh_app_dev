import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

part 'db_controller.dart';

class DbControllerImpl extends DbController {
  final supabase = Supabase.instance.client;

  @override
  Future<void> addNotification(bool isUser, CustomNotification notification,
      ToastificationType type) async {
    await supabase
        .from(DbTables.notificationsTable)
        .insert(notification.toJson(type));
  }

  @override
  Future<List<String>> fetchAllUsers() async {
    return List<String>.from(
        (await supabase.functions.invoke('fetch-all-users-ph'))
            .data
            .map((e) => e['phone_number'])
            .toList());
  }

  @override
  Stream<List<types.Message>> fetchMessagesStream(String roomId) {
    return supabase
        .from(DbTables.messagesTable)
        .stream(primaryKey: ['id'])
        .eq('roomId', roomId)
        .order('createdAt')
        .map((maps) => maps.map((map) => types.Message.fromJson(map)).toList());
  }

  @override
  Stream<List<Conversation>> fetchConversationsStream() {
    List<String> userConversationIds =
        sl<CardWalletPageBloc>().user!.conversations ?? [];
    return supabase
        .from(DbTables.conversationsTable)
        .stream(primaryKey: ['id']).map((maps) => maps
            .map((map) => Conversation.fromJson(map))
            .where((element) => userConversationIds.contains(element.id))
            .toList());
  }
}
