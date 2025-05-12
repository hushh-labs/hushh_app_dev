part of 'bloc.dart';

/// Default State
@immutable
abstract class SignUpPageState extends Equatable {
  const SignUpPageState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class SignUpPageInitialState extends SignUpPageState {}

class SigningUpErrorState extends SignUpPageState {}

class SigningUpState extends SignUpPageState {}

class DateUpdatingState extends SignUpPageState {}

class DateUpdatedState extends SignUpPageState {
  final DateTime dateTime;

  DateUpdatedState(this.dateTime);
}

class BasicInfoUpdatingState extends SignUpPageState {}

class BasicInfoUpdatedState extends SignUpPageState {}

class GoingToNextPageState extends SignUpPageState {}

class OnNextPageState extends SignUpPageState {}