import 'dart:developer';

import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/data_sources/chat_supabase_data_source.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatSupabaseDataSourceImpl extends ChatSupabaseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<void> sendMessage(Message message) async {
    await supabase.from(DbTables.messagesTable).insert(message.toJson());
  }

  @override
  Future<void> updateMessage(Message message) async {
    await supabase
        .from(DbTables.messagesTable)
        .update(message.toJson())
        .match({'id': message.id});
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMessages(String roomId) async {
    return await supabase
        .from(DbTables.messagesTable)
        .select()
        .eq('roomId', roomId);
  }

  @override
  Future<void> sendAiMessage(Message message) async {
    await supabase.from(DbTables.aiMessagesTable).insert(message.toJson());
  }

  @override
  Future<void> updateAiMessage(Message message) async {
    await supabase
        .from(DbTables.aiMessagesTable)
        .update(message.toJson())
        .eq('id', message.id)
        .eq('roomId', message.roomId!);
  }

  @override
  Future<List<Map<String, dynamic>>>  fetchAiMessages(String roomId) async {
    return await supabase
        .from(DbTables.aiMessagesTable)
        .select()
        .eq('roomId', roomId).order('createdAt');
  }

  @override
  Future<void> deleteConversation(Conversation conversation) async {
    await supabase
        .from(DbTables.conversationsTable)
        .delete()
        .eq('id', conversation.id);
  }

  @override
  Future<Map<String, dynamic>?> fetchConversation(String conversationId) async {
    final data = await supabase
        .from(DbTables.conversationsTable)
        .select()
        .eq('id', conversationId)
        .limit(1);
    return data.isEmpty ? null : data.first;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchConversations() async {
    final userIds = AppLocalStorage.user?.conversations ?? [];
    return await supabase
        .from(DbTables.conversationsTable)
        .select()
        .filter('id', 'in', userIds);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPaymentRequest(String pId) async {
    return await supabase
        .from(DbTables.paymentRequestsTable)
        .select()
        .eq('id', pId);
  }

  @override
  Future<void> insertConversation(Conversation conversation) async {
    log("added: ${conversation.toJson()}");
    await supabase
        .from(DbTables.conversationsTable)
        .insert(conversation.toJson());
  }

  @override
  Future<void> updateConversation(Conversation conversation) async {
    await supabase
        .from(DbTables.conversationsTable)
        .update(conversation.toJson())
        .eq('id', conversation.id);
  }

  @override
  Future<void> insertPayment(PaymentModel payment) async {
    await supabase.from(DbTables.paymentRequestsTable).insert(payment.toJson());
  }

  @override
  Future<void> updatePayment(PaymentModel payment) async {
    await supabase
        .from(DbTables.paymentRequestsTable)
        .update(payment.toJson())
        .eq('id', payment.id);
  }
}
