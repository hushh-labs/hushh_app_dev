import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';

import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/hushh_meet_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:intl/intl.dart';

class MeetingView extends StatefulWidget {
  const MeetingView({super.key});

  @override
  State<MeetingView> createState() => _MeetingViewState();
}

class _MeetingViewState extends State<MeetingView> {
  final controller = sl<HushhMeetBloc>();
  @override
  void initState() {
    controller.add(const FetchMeetingsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: controller,
      builder: (context, state) {
        return CalendarControllerProvider(
          controller: EventController(),
          child: WeekView(
            controller: controller.calendarController,
            // showVerticalLines: false,
            showLiveTimeLineInAllDays: true,
            onEventTap: (event, date) {
              Navigator.pushNamed(context, AppRoutes.agentMeetingInfo,
                  arguments: event.first.event as MeetingModel);
            },
            hourIndicatorSettings:
                const HourIndicatorSettings(color: Colors.white12),
            headerStyle: const HeaderStyle(
                decoration: BoxDecoration(color: Colors.white)),
            headerStringBuilder: (DateTime startDate,
                    {DateTime? secondaryDate}) =>
                DateFormat('MMMM').format(DateTime(0, startDate.month)),
          ),
        );
      },
    );
  }
}
