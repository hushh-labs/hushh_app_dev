part of 'bloc.dart';

abstract class AuthPageEvent extends Equatable {
  const AuthPageEvent();

  @override
  List<Object> get props => [];
}

// add events here
class AuthenticateWithPhoneEvent extends AuthPageEvent {
  final BuildContext context;

  const AuthenticateWithPhoneEvent(this.context);
}

class AuthenticateWithGoogleEvent extends AuthPageEvent {
  final BuildContext context;

  const AuthenticateWithGoogleEvent(this.context);
}

class AuthenticateWithAppleEvent extends AuthPageEvent {
  final BuildContext context;

  const AuthenticateWithAppleEvent(this.context);
}

class InitializeEvent extends AuthPageEvent {
  final bool isInitState;

  const InitializeEvent(this.isInitState);
}

class DisposeEvent extends AuthPageEvent {}

class OnBackClickedEvent extends AuthPageEvent {
  final BuildContext context;

  const OnBackClickedEvent(this.context);
}

class OnPhoneUpdateEvent extends AuthPageEvent {}

class OnCountryUpdateEvent extends AuthPageEvent {
  final BuildContext context;

  const OnCountryUpdateEvent(this.context);
}

class OnVerifyEvent extends AuthPageEvent {
  final String value;
  final Function()? onVerify;
  final BuildContext context;
  final OtpVerificationType type;

  const OnVerifyEvent(this.value, this.context, {this.onVerify, required this.type});
}

class OnOtpResendEvent extends AuthPageEvent {
  final BuildContext context;
  final OtpVerificationType otpVerificationType;

  const OnOtpResendEvent(this.context, {required this.otpVerificationType});
}

class AuthPageCodeSentEvent extends AuthPageEvent {
  final BuildContext context;

  const AuthPageCodeSentEvent(this.context);
}

class PhoneVerificationFailedEvent extends AuthPageEvent {
  const PhoneVerificationFailedEvent();
}

class CountDownForResendFunction extends AuthPageEvent {
  const CountDownForResendFunction();
}
