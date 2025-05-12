part of 'bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class FetchNotificationsEvent extends NotificationsEvent {}

class AcceptDataConsentRequestEvent extends NotificationsEvent {
  final String requestId;
  final BuildContext context;

  const AcceptDataConsentRequestEvent(this.requestId, this.context);
}