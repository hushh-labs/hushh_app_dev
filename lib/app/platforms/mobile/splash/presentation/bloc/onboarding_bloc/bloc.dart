import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/shared/config/constants/data.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';

part 'events.dart';
part 'states.dart';

class OnboardingPageBloc
    extends Bloc<OnboardingPageEvent, OnboardingPageState> {
  PageController pageController = PageController();

  int get currentPage => (pageController.page ?? 0).toInt();

  bool get lastPage => currentPage == onboardDataList.length - 1;

  UserOnboardStatus get onboardStatus => AppLocalStorage.userOnboardStatus;

  OnboardingPageBloc() : super(OnboardingPageInitialState()) {
    on<OnNextPageIndexEvent>(onNextPageIndexEvent);
    on<OnPageUpdatedEvent>(onPageUpdatedEvent);
  }

  Future<bool> initializeController() {
    Completer<bool> completer = new Completer<bool>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      completer.complete(true);
    });

    return completer.future;
  }

  FutureOr<void> onNextPageIndexEvent(
      OnNextPageIndexEvent event, Emitter<OnboardingPageState> emit) {
    if (lastPage) {
      // AppLocalStorage.tutorialWatched();
      emit(OnboardingPageOnLastPageState());
    } else {
      emit(OnboardingPageOnPageUpdatingState());
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      emit(OnboardingPageOnPageUpdatedState());
    }
  }

  FutureOr<void> onPageUpdatedEvent(
      OnPageUpdatedEvent event, Emitter<OnboardingPageState> emit) {
    emit(OnboardingPageOnPageUpdatingState());
    pageController.animateToPage(event.page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    emit(OnboardingPageOnPageUpdatedState());
  }
}
