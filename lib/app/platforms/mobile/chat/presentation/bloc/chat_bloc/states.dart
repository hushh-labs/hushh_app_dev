part of 'bloc.dart';

/// Default State
@immutable
abstract class ChatPageState extends Equatable {
  const ChatPageState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class ChatPageInitialState extends ChatPageState {}

class MessageSendingState extends ChatPageState {}

class MessageSentState extends ChatPageState {}

class SearchUpdatedState extends ChatPageState {}

class ChatUpdatedState extends ChatPageState {}
