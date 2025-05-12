part of 'bloc.dart';

/// Default State
@immutable
abstract class SplashPageState extends Equatable {
  const SplashPageState();

  @override
  List<Object> get props => [];
}

/// Default Splash Page State
class SplashPageInitialState extends SplashPageState {}

/// when the initial setup is done
class SplashPageInitialSetupDoneState extends SplashPageState {}

/// Splash Screen animation in progress state
class SplashPageLoadingState extends SplashPageState {}

/// Splash Screen animation in completed
class SplashPageLoadedState extends SplashPageState {
  // final double visibility;

  // SplashPageLoadedState({required this.visibility});
}

class SharingUserProfileAndRequirementsWithAgentsState extends SplashPageState {}

class UserProfileAndRequirementsSharedWithAgentsState extends SplashPageState {}