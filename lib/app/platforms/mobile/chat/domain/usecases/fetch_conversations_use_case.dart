import 'package:dartz/dartz.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/repository_impl/chat_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchConversationsUseCase {
  final ChatRepositoryImpl chatRepository;

  FetchConversationsUseCase(this.chatRepository);

  Future<Either<ErrorState, List<Conversation>>> call() async {
    return await chatRepository.fetchConversations();
  }
}
