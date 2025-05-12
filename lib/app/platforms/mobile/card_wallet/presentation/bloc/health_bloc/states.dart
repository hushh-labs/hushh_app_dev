part of 'bloc.dart';

/// Default State
@immutable
abstract class HealthState extends Equatable {
  const HealthState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class HealthInitialState extends HealthState {}

class DataNotFetchedHealth extends HealthState {}

class FetchingDataHealth extends HealthState {}

class DataReadyHealth extends HealthState {}

class NoDataHealth extends HealthState {}

class InsertingHealthDataState extends HealthState {}

class HealthDataInsertedState extends HealthState {}

class FetchingRemoteHealthDataState extends HealthState {}

class RemoteHealthDataFetchedState extends HealthState {}

class RemoteHealthDataFetchFailedState extends HealthState {}
