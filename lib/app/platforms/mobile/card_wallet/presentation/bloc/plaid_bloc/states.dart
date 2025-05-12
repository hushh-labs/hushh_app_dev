part of 'bloc.dart';

/// Default State
@immutable
abstract class PlaidState extends Equatable {
  const PlaidState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class PlaidInitialState extends PlaidState {}

class FetchingNotificationsState extends PlaidState {}

class NotificationsFetchedState extends PlaidState {
  final List<CustomNotification> notifications;

  const NotificationsFetchedState(this.notifications);
}

class FetchingFinanceCardState extends PlaidState {}

class SuccessFinanceCardState extends PlaidState {}

class TransactionsUpdatedState extends PlaidState {}
