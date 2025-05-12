part of 'bloc.dart';

abstract class AgentTaskEvent extends Equatable {
  const AgentTaskEvent();

  @override
  List<Object> get props => [];
}

class FetchTasksEvent extends AgentTaskEvent {}

class CreateNewTaskEvent extends AgentTaskEvent {
  final BuildContext context;

  const CreateNewTaskEvent(this.context);
}

class UpdateTaskTypeEvent extends AgentTaskEvent {
  final BuildContext context;

  const UpdateTaskTypeEvent(this.context);
}

class DeleteTaskEvent extends AgentTaskEvent {
  final TaskModel task;
  final BuildContext context;

  const DeleteTaskEvent(this.task, this.context);
}

class SelectDateAndTimeEvent extends AgentTaskEvent {
  final BuildContext context;

  const SelectDateAndTimeEvent(this.context);
}

class UpdateDateEvent extends AgentTaskEvent {
  final DateTime dateTime;

  const UpdateDateEvent(this.dateTime);
}
