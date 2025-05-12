part of 'bloc.dart';

abstract class HealthEvent extends Equatable {
  const HealthEvent();

  @override
  List<Object> get props => [];
}

class FetchHealthDataEvent extends HealthEvent {
  final bool refresh;
  final BuildContext? context;

  const FetchHealthDataEvent({this.refresh = false, this.context});
}

class InsertHealthDataEvent extends HealthEvent {
  final Map<HealthDataType, List<Map<String, dynamic>>> data;

  const InsertHealthDataEvent(this.data);
}

class FetchRemoteHealthDataEvent extends HealthEvent {}