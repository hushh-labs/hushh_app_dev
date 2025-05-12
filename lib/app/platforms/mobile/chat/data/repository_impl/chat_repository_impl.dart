import 'package:dartz/dartz.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/data_sources/chat_supabase_data_source.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/data_sources/chat_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/repository/chat_repository.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_handler.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatSupabaseDataSourceImpl chatSupabaseDataSource;

  ChatRepositoryImpl(this.chatSupabaseDataSource);

  @override
  Future<Either<ErrorState, void>> sendAiMessage(Message message) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.sendAiMessage(message), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> updateAiMessage(Message message) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.updateAiMessage(message), (value) {});
  }

  @override
  Future<Either<ErrorState, List<Message>>> fetchAiMessages(
      String roomId) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.fetchAiMessages(roomId), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => Message.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, void>> deleteConversation(
      Conversation conversation) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.deleteConversation(conversation), (value) {});
  }

  @override
  Future<Either<ErrorState, Conversation?>> fetchConversation(
      String conversationId) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.fetchConversation(conversationId), (value) {
      if (value != null) {
        final conversation = Conversation.fromJson(value);
        return conversation;
      }
      return null;
    });
  }

  @override
  Future<Either<ErrorState, List<Message>>> fetchMessages(String roomId) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.fetchMessages(roomId), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => Message.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, void>> insertConversation(
      Conversation conversation) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.insertConversation(conversation), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> insertPayment(PaymentModel payment) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.insertPayment(payment), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> sendMessage(Message message) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.sendMessage(message), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> updateConversation(
      Conversation conversation) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.updateConversation(conversation), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> updateMessage(Message message) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.updateMessage(message), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> updatePayment(PaymentModel payment) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.updatePayment(payment), (value) {});
  }

  @override
  Future<Either<ErrorState, List<Conversation>>> fetchConversations() async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.fetchConversations(), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => Conversation.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<PaymentModel>>> fetchPaymentRequest(String pId) async {
    return await ErrorHandler.callSupabase(
            () => chatSupabaseDataSource.fetchPaymentRequest(pId), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => PaymentModel.fromJson(e)).toList();
    });
  }
}
