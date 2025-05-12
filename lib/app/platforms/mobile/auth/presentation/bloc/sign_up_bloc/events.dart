part of 'bloc.dart';

abstract class SignUpPageEvent extends Equatable {
  const SignUpPageEvent();

  @override
  List<Object> get props => [];
}

// add events here
class SelectDateEvent extends SignUpPageEvent {
  final BuildContext context;

  const SelectDateEvent(this.context);
}

class UpdateDateEvent extends SignUpPageEvent {
  final DateTime dateTime;

  const UpdateDateEvent(this.dateTime);
}

class SignUpEvent extends SignUpPageEvent {
  final BuildContext context;
  final UserOnboardStatus onboardStatus;

  const SignUpEvent(this.context, {this.onboardStatus = UserOnboardStatus.loggedIn});
}

class OnBackPressedEvent extends SignUpPageEvent {
  final BuildContext context;

  const OnBackPressedEvent(this.context);
}

class SignUpInitializeEvent extends SignUpPageEvent {}

class OnNextUserGuideClickedEvent extends SignUpPageEvent {
  final bool isValidated;
  final UserGuideQuestionType question;
  final BuildContext context;

  const OnNextUserGuideClickedEvent({
    required this.isValidated,
    required this.question,
    required this.context,
  });
}
