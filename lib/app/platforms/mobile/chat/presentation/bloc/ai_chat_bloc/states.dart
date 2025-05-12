part of 'bloc.dart';

/// Default State
@immutable
abstract class AiChatPageState extends Equatable {
  const AiChatPageState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class AiChatPageInitialState extends AiChatPageState {}

class MessageSendingState extends AiChatPageState {}

class MessageSentState extends AiChatPageState {}

class SearchUpdatedState extends AiChatPageState {}

class ChatUpdatedState extends AiChatPageState {}

class FetchingMessageState extends AiChatPageState {}

class FetchedState extends AiChatPageState {}