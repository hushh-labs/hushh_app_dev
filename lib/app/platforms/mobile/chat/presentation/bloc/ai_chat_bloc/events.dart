part of 'bloc.dart';

abstract class AiChatPageEvent extends Equatable {
  const AiChatPageEvent();

  @override
  List<Object> get props => [];
}

// add events here
class FetchMessagesEvent extends AiChatPageEvent {}

class SendMessageEvent extends AiChatPageEvent {
  final types.Message message;

  const SendMessageEvent(this.message);
}

class UpdateMessageEvent extends AiChatPageEvent {
  final types.Message message;

  const UpdateMessageEvent(this.message);
}
