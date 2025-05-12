part of 'bloc.dart';

abstract class ChatPageEvent extends Equatable {
  const ChatPageEvent();

  @override
  List<Object> get props => [];
}

// add events here
class SendMessageEvent extends ChatPageEvent {
  final types.Message message;
  final Conversation conversation;

  const SendMessageEvent(this.message, this.conversation);
}

class UpdateMessageEvent extends ChatPageEvent {
  final types.Message message;
  final Conversation conversation;

  const UpdateMessageEvent(this.message, this.conversation);
}

class InitiateChatEvent extends ChatPageEvent {
  final BuildContext context;
  final File? file;
  final String uid;
  final CardModel? brand;

  const InitiateChatEvent(this.context, this.file, this.uid, {this.brand});
}

class DeleteChatEvent extends ChatPageEvent {
  final Conversation conversation;
  final BuildContext context;

  const DeleteChatEvent(this.conversation, this.context);
}

class SearchEvent extends ChatPageEvent {
  final String value;
  final Function(Function()) setState;

  const SearchEvent(this.value, this.setState);
}

class PaymentStatusUpdateEvent extends ChatPageEvent {
  final PaymentModel paymentModel;

  const PaymentStatusUpdateEvent({
    required this.paymentModel,
  });
}

class ResetUnReadCountEvent extends ChatPageEvent {
  final Conversation conversation;

  const ResetUnReadCountEvent(this.conversation);
}

class InsertPaymentRequest extends ChatPageEvent {
  final PaymentModel paymentModel;

  const InsertPaymentRequest(this.paymentModel);
}

class FetchPaymentRequestAndMakePaymentAsUserEvent extends ChatPageEvent {
  final String pId;
  final BuildContext context;

  const FetchPaymentRequestAndMakePaymentAsUserEvent({required this.pId, required this.context});
}