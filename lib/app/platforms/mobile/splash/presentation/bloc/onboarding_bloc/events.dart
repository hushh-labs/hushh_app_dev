part of 'bloc.dart';

abstract class OnboardingPageEvent extends Equatable {
  const OnboardingPageEvent();

  @override
  List<Object> get props => [];
}

class OnPageUpdatedEvent extends OnboardingPageEvent {
  final int page;

  OnPageUpdatedEvent(this.page);
}

class OnNextPageIndexEvent extends OnboardingPageEvent {}
