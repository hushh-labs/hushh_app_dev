import 'package:dartz/dartz.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/repository_impl/chat_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchAiMessagesUseCase {
  final ChatRepositoryImpl chatRepository;

  FetchAiMessagesUseCase(this.chatRepository);

  Future<Either<ErrorState, List<Message>>> call({required String roomId}) async {
    return await chatRepository.fetchAiMessages(roomId);
  }
}
