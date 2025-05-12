part of 'bloc.dart';

/// Default State
@immutable
abstract class AgentTaskState extends Equatable {
  const AgentTaskState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class AgentTaskInitialState extends AgentTaskState {}

class FetchingNotificationsState extends AgentTaskState {}

class NotificationsFetchedState extends AgentTaskState {
  final List<CustomNotification> notifications;

  const NotificationsFetchedState(this.notifications);
}

class CreateTaskState extends AgentTaskState {}

class CreateTaskErrorState extends AgentTaskState {}

class SelectTaskTypeState extends AgentTaskState {}

class TaskUpdatingState extends AgentTaskState {}

class TaskUpdatedState extends AgentTaskState {}

class FetchingTasksState extends AgentTaskState {}

class FetchedTaskState extends AgentTaskState {}

