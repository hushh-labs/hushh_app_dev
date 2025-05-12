import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/accept_data_consent_request_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_agent_notifications_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_notifications_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:toastification/toastification.dart';

part 'events.dart';

part 'states.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final FetchNotificationsUseCase fetchNotificationsUseCase;
  final FetchAgentNotificationsUseCase fetchAgentNotificationsUseCase;
  final AcceptDataConsentRequestUseCase acceptDataConsentRequestUseCase;

  NotificationsBloc(
    this.fetchNotificationsUseCase,
    this.fetchAgentNotificationsUseCase,
    this.acceptDataConsentRequestUseCase,
  ) : super(NotificationsPageInitialState()) {
    on<FetchNotificationsEvent>(fetchNotificationsEvent);
    on<AcceptDataConsentRequestEvent>(acceptDataConsentRequestEvent);
  }

  List<CustomNotification>? notifications;

  bool get noNotificationFound => notifications?.isEmpty ?? true;

  FutureOr<void> fetchNotificationsEvent(
      FetchNotificationsEvent event, Emitter<NotificationsState> emit) async {
    emit(FetchingNotificationsState());
    if (AppLocalStorage.hushhId == null) {
      return;
    }
    if (sl<CardWalletPageBloc>().isUser) {
      final result =
          await fetchNotificationsUseCase(uid: AppLocalStorage.hushhId!);
      result.fold((l) => null, (r) {
        notifications = r;
        emit(NotificationsFetchedState(r));
      });
    } else {
      final result =
          await fetchAgentNotificationsUseCase(uid: AppLocalStorage.hushhId!);
      result.fold((l) => null, (r) {
        notifications = r;
        emit(NotificationsFetchedState(r));
      });
    }
    // sl<CardWalletPageBloc>().isUser
    //     ? fireStore
    //         .collection("HushUsers")
    //         .doc(AppLocalStorage.currentUserUid)
    //         .collection("notifications")
    //         .orderBy('date_time', descending: true)
    //         .snapshots()
    //     : fireStore
    //         .collection("HushUsers")
    //         .doc(AppLocalStorage.currentUserUid)
    //         .collection("agent_notifications")
    //         .orderBy('date_time', descending: true)
    //         .snapshots();
    //
    // result
  }

  FutureOr<void> acceptDataConsentRequestEvent(
      AcceptDataConsentRequestEvent event,
      Emitter<NotificationsState> emit) async {
    emit(AcceptingDataConsentRequestState());
    if (AppLocalStorage.hushhId == null) {
      return;
    }
    final result =
        await acceptDataConsentRequestUseCase(requestId: event.requestId);
    result.fold((l) => emit(DataConsentRequestErrorState()), (r) {
      ToastManager(Toast(
        title: 'Consent granted',
        type: ToastificationType.success
      )).show(event.context);
      Navigator.pop(event.context);
      emit(DataConsentRequestAcceptedState());
    });
  }
}
