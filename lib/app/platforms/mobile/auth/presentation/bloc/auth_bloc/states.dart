part of 'bloc.dart';

/// Default State
@immutable
abstract class AuthPageState extends Equatable {
  const AuthPageState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class AuthPageInitialState extends AuthPageState {}

class InitializingState extends AuthPageState {
  final bool isInitState;

  const InitializingState(this.isInitState);
}

class InitializedState extends AuthPageState {}

class PhoneVerificationInitiatedState extends AuthPageState {}

class PhoneVerificationFailedState extends AuthPageState {}

class OtpSendForVerificationState extends AuthPageState {}

class AuthenticatingWithGoogleState extends AuthPageState {}

class AuthenticationCompleteWithGoogleState extends AuthPageState {}

class AuthenticatingWithAppleState extends AuthPageState {}

class AuthenticationCompleteWithAppleState extends AuthPageState {}

class PhoneUpdatingState extends AuthPageState {}

class PhoneUpdatedState extends AuthPageState {}

class CountryUpdatingState extends AuthPageState {}

class CountryUpdatedState extends AuthPageState {}

class PhoneVerifyingState extends AuthPageState {}

class PhoneVerifiedState extends AuthPageState {}

class ResendingOtpState extends AuthPageState {}

class EmailVerifyingState extends AuthPageState {}
