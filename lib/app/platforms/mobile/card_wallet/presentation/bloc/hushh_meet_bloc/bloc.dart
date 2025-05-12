// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:calendar_view/calendar_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/delete_meet_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_meet_info_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_meetings_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_meet_info_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_meet_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/update_meet_info_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/send_message_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/update_conversation_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/components/payment_methods.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/google_calendar.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

part 'events.dart';

part 'states.dart';

class HushhMeetBloc extends Bloc<HushhMeetEvent, HushhMeetState> {
  final FetchHushhMeetInfoUseCase fetchHushhMeetInfoUseCase;
  final InsertHushhMeetInfoUseCase insertHushhMeetInfoUseCase;
  final UpdateHushhMeetInfoUseCase updateHushhMeetInfoUseCase;
  final InsertMeetUseCase insertMeetUseCase;
  final FetchMeetingsUseCase fetchMeetingsUseCase;
  final DeleteMeetUseCase deleteMeetUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final UpdateConversationUseCase updateConversationUseCase;

  HushhMeetBloc(
    this.fetchHushhMeetInfoUseCase,
    this.insertHushhMeetInfoUseCase,
    this.updateHushhMeetInfoUseCase,
    this.insertMeetUseCase,
    this.fetchMeetingsUseCase,
    this.deleteMeetUseCase,
    this.sendMessageUseCase,
    this.updateConversationUseCase,
  ) : super(HushhMeetInitialState()) {
    on<FetchMeetInfoEvent>(fetchMeetInfoEvent);
    on<FetchMeetInfoAsUserEvent>(fetchMeetInfoAsUserEvent);
    on<UpdateMeetInfoEvent>(updateMeetInfoEvent);
    on<UserConfirmMeetEvent>(userConfirmMeetEvent);
    on<CreateMeetingEvent>(createMeetingEvent);
    on<DeleteMeetingEvent>(deleteMeetingEvent);
    on<FetchMeetingsEvent>(fetchMeetingsEvent);
  }

  // HushhMeet
  AgentMeeting? meeting;
  TextEditingController eventNameController = TextEditingController();

  // Agent Meet Schedule
  EventController calendarController = EventController();
  final TextEditingController meetDateTimeController = TextEditingController();
  final TextEditingController meetDurationController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController meetDescriptionController =
      TextEditingController();

  defaultAgent() async {
    return AgentMeeting(
      isActivated: false,
      selectedSlots: {},
      timeZone: await FlutterNativeTimezone.getLocalTimezone(),
      currency: sl<HomePageBloc>().currency?.shorten() ?? defaultCurrency.shorten(),
      name: eventNameController.text,
      duration: const Duration(minutes: 30),
      dayTimings: {
        'Monday': TimeRange(
            startTime: const TimeOfDay(hour: 9, minute: 0),
            endTime: const TimeOfDay(hour: 17, minute: 0)),
        'Tuesday': TimeRange(
            startTime: const TimeOfDay(hour: 9, minute: 0),
            endTime: const TimeOfDay(hour: 17, minute: 0)),
        'Wednesday': TimeRange(
            startTime: const TimeOfDay(hour: 9, minute: 0),
            endTime: const TimeOfDay(hour: 17, minute: 0)),
        'Thursday': TimeRange(
            startTime: const TimeOfDay(hour: 9, minute: 0),
            endTime: const TimeOfDay(hour: 17, minute: 0)),
        'Friday': TimeRange(
            startTime: const TimeOfDay(hour: 9, minute: 0),
            endTime: const TimeOfDay(hour: 17, minute: 0)),
        'Saturday': TimeRange(
            startTime: const TimeOfDay(hour: 9, minute: 0),
            endTime: const TimeOfDay(hour: 17, minute: 0)),
        'Sunday': TimeRange(
            startTime: const TimeOfDay(hour: 9, minute: 0),
            endTime: const TimeOfDay(hour: 17, minute: 0)),
      },
      collectPayment: false,
      amount: 0,
      hushhId: AppLocalStorage.hushhId!,
    );
  }

  FutureOr<void> fetchMeetInfoEvent(
      FetchMeetInfoEvent event, Emitter<HushhMeetState> emit) async {
    emit(FetchingMeetingInfoState());
    final result =
        await fetchHushhMeetInfoUseCase(uid: AppLocalStorage.hushhId!);
    await result.fold((l) {}, (r) async {
      if (r != null) {
        eventNameController.text = r.name;
        List<String> sortedKeys = r.dayTimings.keys.toList()
          ..sort((a, b) =>
              Utils().getWeekdayIndex(a).compareTo(Utils().getWeekdayIndex(b)));
        Map<String, TimeRange> sortedTimeRanges = {};
        for (var key in sortedKeys) {
          sortedTimeRanges[key] = r.dayTimings[key]!;
        }
        r.dayTimings = sortedTimeRanges;
        meeting = r;
        emit(MeetingInfoFetchedState());
      } else {
        eventNameController = TextEditingController(
            text: "Meet w/ ${AppLocalStorage.agent!.agentName}");
        r = await defaultAgent();
        meeting = r;
        await insertHushhMeetInfoUseCase(meeting: r!);
        emit(MeetingInfoFetchedState());
      }
    });
  }

  FutureOr<void> updateMeetInfoEvent(
      UpdateMeetInfoEvent event, Emitter<HushhMeetState> emit) async {
    meeting?.name = eventNameController.text;
    emit(FetchingMeetingInfoState());
    if (meeting != null) {
      updateHushhMeetInfoUseCase(meeting: meeting!);
    }
    emit(MeetingInfoFetchedState());
  }

  FutureOr<void> fetchMeetInfoAsUserEvent(
      FetchMeetInfoAsUserEvent event, Emitter<HushhMeetState> emit) async {
    emit(FetchingMeetingInfoState());
    final result = await fetchHushhMeetInfoUseCase(
        uid: sl<CardWalletPageBloc>().selectedAgent!.hushhId!);
    result.fold((l) {
      print("boooza error");
    }, (r) {
      print("boooza suc $r");
      if (r != null) {
        List<String> sortedKeys = r.dayTimings.keys.toList()
          ..sort((a, b) =>
              Utils().getWeekdayIndex(a).compareTo(Utils().getWeekdayIndex(b)));
        Map<String, TimeRange> sortedTimeRanges = {};
        for (var key in sortedKeys) {
          sortedTimeRanges[key] = r.dayTimings[key]!;
        }
        r.dayTimings = sortedTimeRanges;
        meeting = r;
      }
    });
    emit(MeetingInfoFetchedState());
  }

  FutureOr<void> userConfirmMeetEvent(
      UserConfirmMeetEvent event, Emitter<HushhMeetState> emit) async {
    onPaymentSuccess(TimeRange selectedTimeInAgentTimeZone) async {
      Tuple2<String?, String?>? googleMeetData = await GoogleCalendar.insert(
        title: meeting!.name,
        description: "",
        location: 'Google Meet: Online',
        attendeeEmailList: [
          // AppLocalStorage.agent!,
          sl<CardWalletPageBloc>().selectedAgent!
        ]
            .map((e) => cal.EventAttendee(
                email: e.agentWorkEmail,
                id: const Uuid().v4(),
                displayName: e.agentName,
                organizer: e.hushhId == AppLocalStorage.hushhId,
                self: e.hushhId == AppLocalStorage.hushhId))
            .toList(),
        shouldNotifyAttendees: true,
        hasConferenceSupport: true,
        startTime: event.selectedDate.copyWith(
          hour: selectedTimeInAgentTimeZone.startTime.hour,
          minute: selectedTimeInAgentTimeZone.startTime.minute,
        ),
        endTime: event.selectedDate.copyWith(
          hour: selectedTimeInAgentTimeZone.endTime.hour,
          minute: selectedTimeInAgentTimeZone.endTime.minute,
        ),
      );
      final meetingModel = MeetingModel(
          id: const Uuid().v4(),
          title: meeting!.name,
          desc: "",
          dateTime: event.selectedDate.copyWith(
            hour: selectedTimeInAgentTimeZone.startTime.hour,
            minute: selectedTimeInAgentTimeZone.startTime.minute,
          ),
          organizerId: sl<CardWalletPageBloc>().user!.hushhId!,
          duration: meeting!.duration,
          lat: null,
          long: null,
          participantsIds: [sl<CardWalletPageBloc>().selectedAgent!.hushhId!],
          meetingType: MeetingType.online,
          gEventId: googleMeetData?.item1,
          gMeetLink: googleMeetData?.item2);
      add(CreateMeetingEvent(meetingModel, event.context));
      meeting!.selectedSlots[event.selectedDate] ??= [];
      meeting!.selectedSlots[event.selectedDate]
          ?.add(selectedTimeInAgentTimeZone);
      updateHushhMeetInfoUseCase(
              meeting: meeting!,
              uid: sl<CardWalletPageBloc>().selectedAgent?.hushhId)
          .then((result) {
        Navigator.pop(event.context);
        result.fold((l) => null, (r) {
          ToastManager(Toast(
                  title: "Meeting scheduled successfully!",
                  description: "We've shared an invite with the agent.",
                  type: ToastificationType.success))
              .show(event.context);
        });
      });
    }

    emit(ConfirmingMeetState());
    String agentTimeZone = meeting!.timeZone;
    List<String> timeParts = event.slot.split(' - ');
    TimeOfDay startTime = Utils().convertTimeOfDayTimeZone(
        TimeOfDay(
          hour: int.parse(timeParts[0].split(':')[0]),
          minute: int.parse(timeParts[0].split(':')[1]),
        ),
        agentTimeZone);
    TimeOfDay endTime = Utils().convertTimeOfDayTimeZone(
        TimeOfDay(
          hour: int.parse(timeParts[1].split(':')[0]),
          minute: int.parse(timeParts[1].split(':')[1]),
        ),
        agentTimeZone);
    TimeRange selectedTimeInAgentTimeZone =
        TimeRange(startTime: startTime, endTime: endTime);
    if (meeting!.collectPayment) {
      Navigator.pushNamed(event.context, AppRoutes.shared.paymentMethodsViewer,
          arguments: PaymentMethodsArgs(
            amount: meeting!.amount,
            currency: sl<HomePageBloc>().currency,
            description: "Pay ${meeting!.amount} to schedule the call!",
            onPaymentDone: () async {
              Navigator.pop(event.context);
              ToastManager(Toast(
                      title: 'Transaction success!',
                      type: ToastificationType.success))
                  .show(event.context);
              onPaymentSuccess(selectedTimeInAgentTimeZone);
            },
            onPaymentFailed: () {
              ToastManager(Toast(
                      title: 'Transaction failed!',
                      type: ToastificationType.error))
                  .show(event.context);
            },
          ));
    } else {
      onPaymentSuccess(selectedTimeInAgentTimeZone);
    }

    emit(MeetConfirmedState());
  }

  FutureOr<void> createMeetingEvent(
      CreateMeetingEvent event, Emitter<HushhMeetState> emit) async {
    final myUser = types.User(
        id: AppLocalStorage.hushhId!,
        firstName: sl<CardWalletPageBloc>().user!.name);

    final message = types.CustomMessage(
        author: myUser,
        id: const Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        metadata: {"type": "meeting", "data": event.meeting.toJson()});

    emit(CreatingNewMeetingState());
    final result = await insertMeetUseCase(meeting: event.meeting);
    await result.fold((l) => null, (r) async {
      await Future.wait(
          List.generate(event.meeting.participantsIds.length, (index) async {
        final data = await sl<ChatPageBloc>().initiateChat(
            InitiateChatEvent(
              event.context,
              null,
              event.meeting.participantsIds[index],
            ),
            dialog: false);
        await data.fold((l) => null, (data) async {
          return Future.wait([
            insertMeetUseCase(meeting: event.meeting),
            sendMessageUseCase(
                message: message.copyWith(roomId: data.item1.id,
          remoteId: event.meeting.participantsIds[index],)),
            updateConversationUseCase(
                conversation: data.item1.copyWith(lastMessage: message)),
          ]);
        });
      }));

      sl<ChatPageBloc>().updateChatsInRealtime();
      add(const FetchMeetingsEvent());
      // Navigator.pop(event.context);
      ToastManager(Toast(
              title: 'Meeting scheduled successfully!',
              notification: CustomNotification(
                title: 'Meeting scheduled successfully!',
                description:
                    'Your ${event.meeting.meetingType.name} meeting is scheduled at ${DateFormat('dd MMM, yyyy').format(event.meeting.dateTime)}',
                route: '/MeetInfo?cardId=${event.meeting.id}',
              ),
              type: ToastificationType.success))
          .show(event.context);
      emit(NewMeetingCreatedState());
    });
  }

  FutureOr<void> fetchMeetingsEvent(
      FetchMeetingsEvent event, Emitter<HushhMeetState> emit) async {
    if(AppLocalStorage.hushhId == null) {
      return;
    }
    calendarController = EventController();
    emit(FetchingMeetingsState());
    final result = await fetchMeetingsUseCase(uid: AppLocalStorage.hushhId!);
    result.fold((l) => null, (meetings) {
      for (var meeting in meetings) {
        calendarController.add(CalendarEventData(
          title: meeting.title,
          event: meeting,
          description: meeting.desc,
          startTime: meeting.dateTime,
          endTime: meeting.dateTime
              .add(meeting.duration ?? const Duration(hours: 1)),
          date: meeting.dateTime,
        ));
      }
      emit(MeetingsFetchedState());
    });
  }

  FutureOr<void> deleteMeetingEvent(
      DeleteMeetingEvent event, Emitter<HushhMeetState> emit) async {
    emit(FetchingMeetingsState());
    final result = await deleteMeetUseCase(meeting: event.meeting);
    result.fold((l) => null, (r) {
      Navigator.pop(event.context);
      ToastManager(Toast(
        title: 'Meeting removed successfully',
        type: ToastificationType.success,
      )).show(event.context);
      emit(MeetingsFetchedState());
      add(const FetchMeetingsEvent());
    });
  }
}
