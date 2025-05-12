import 'package:dartz/dartz.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';

abstract class ChatRepository {
  Future<Either<ErrorState, void>> sendAiMessage(Message message);

  Future<Either<ErrorState, void>> updateAiMessage(Message message);

  Future<Either<ErrorState, List<Message>>> fetchAiMessages(String roomId);

  Future<Either<ErrorState, void>> sendMessage(Message message);

  Future<Either<ErrorState, void>> updateMessage(Message message);

  Future<Either<ErrorState, List<Message>>> fetchMessages(String roomId);

  Future<Either<ErrorState, void>> updateConversation(Conversation conversation);

  Future<Either<ErrorState, void>> deleteConversation(Conversation conversation);

  Future<Either<ErrorState, void>> updatePayment(PaymentModel payment);

  Future<Either<ErrorState, void>> insertPayment(PaymentModel payment);

  Future<Either<ErrorState, Conversation?>> fetchConversation(String conversationId);

  Future<Either<ErrorState, List<Conversation>>> fetchConversations();

  Future<Either<ErrorState, void>> insertConversation(Conversation conversation);

  Future<Either<ErrorState, List<PaymentModel>>> fetchPaymentRequest(String pId);
}
