part of 'bloc.dart';

/// Default State
@immutable
abstract class OnboardingPageState extends Equatable {
  const OnboardingPageState();

  @override
  List<Object> get props => [];
}

/// Default Splash Page State
class OnboardingPageInitialState extends OnboardingPageState {}

/// when the initial setup is done
class OnboardingPageOnLastPageState extends OnboardingPageState {}

/// When
class OnboardingPageOnPageUpdatingState extends OnboardingPageState {}

///
class OnboardingPageOnPageUpdatedState extends OnboardingPageState {}
