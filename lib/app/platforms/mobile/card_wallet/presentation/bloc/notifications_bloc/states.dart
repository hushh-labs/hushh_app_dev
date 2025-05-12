part of 'bloc.dart';

/// Default State
@immutable
abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class NotificationsPageInitialState extends NotificationsState {}

class FetchingNotificationsState extends NotificationsState {}

class NotificationsFetchedState extends NotificationsState {
  final List<CustomNotification> notifications;

  const NotificationsFetchedState(this.notifications);
}

class AcceptingDataConsentRequestState extends NotificationsState {}

class DataConsentRequestAcceptedState extends NotificationsState {}

class DataConsentRequestErrorState extends NotificationsState {}