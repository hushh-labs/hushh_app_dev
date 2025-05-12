part of 'bloc.dart';

/// Default State
@immutable
abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class HomePageInitialState extends HomePageState {}

class ActiveScreenUpdatingState extends HomePageState {}

class ActiveScreenUpdatedState extends HomePageState {
  final int index;

  ActiveScreenUpdatedState(this.index);
}

class UpdatingProfileImageState extends HomePageState {}

class ProfileImageUpdatedState extends HomePageState {}
