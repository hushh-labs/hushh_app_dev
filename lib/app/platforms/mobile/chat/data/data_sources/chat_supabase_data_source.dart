import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';

abstract class ChatSupabaseDataSource {
  Future<void> sendMessage(Message message);

  Future<void> updateMessage(Message message);

  Future<void> sendAiMessage(Message message);

  Future<void> updateAiMessage(Message message);

  Future<List<Map<String, dynamic>>> fetchMessages(String roomId);

  Future<List<Map<String, dynamic>>> fetchAiMessages(String roomId);

  Future<void> deleteConversation(Conversation conversation);

  Future<Map<String, dynamic>?> fetchConversation(String conversationId);

  Future<List<Map<String, dynamic>>> fetchConversations();

  Future<List<Map<String, dynamic>>> fetchPaymentRequest(String pId);

  Future<void> insertConversation(Conversation conversation);

  Future<void> updateConversation(Conversation conversation);

  Future<void> insertPayment(PaymentModel payment);

  Future<void> updatePayment(PaymentModel payment);
}
