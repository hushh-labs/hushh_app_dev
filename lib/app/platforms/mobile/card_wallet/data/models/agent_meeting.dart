import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AgentMeeting {
  bool isActivated;
  String name;
  Duration duration;
  Map<String, TimeRange> dayTimings;
  Map<DateTime, List<TimeRange>> selectedSlots;
  bool collectPayment;
  double amount;
  String currency;
  String timeZone;
  String hushhId;

  AgentMeeting({
    required this.isActivated,
    required this.name,
    required this.duration,
    required this.dayTimings,
    required this.selectedSlots,
    required this.collectPayment,
    required this.amount,
    required this.currency,
    required this.timeZone,
    required this.hushhId,
  });

  factory AgentMeeting.fromJson(Map<String, dynamic> json) {
    Map<String, TimeRange> dayTimings = {};
    json['dayTimings'].forEach((key, value) {
      dayTimings[key] = TimeRange(
        startTime: _parseTimeOfDay(value['startTime']),
        endTime: _parseTimeOfDay(value['endTime']),
      );
    });
    Map<DateTime, List<TimeRange>> slots = {};
    json['selectedSlots'].forEach((key, value) {
      slots[DateFormat('yyyy-MM-dd').parse(key)] = List<TimeRange>.from(value
          .map((e) => TimeRange(
                startTime: _parseTimeOfDay(e['startTime']),
                endTime: _parseTimeOfDay(e['endTime']),
              ))
          .toList());
    });

    return AgentMeeting(
      isActivated: json['isActivated'],
      name: json['name'],
      duration: Duration(minutes: json['duration']),
      dayTimings: dayTimings,
      selectedSlots: slots,
      collectPayment: json['collectPayment'],
      amount: double.tryParse(json['amount']?.toString() ?? "0") ?? 0,
      timeZone: json['timeZone'],
      currency: json['currency'],
      hushhId: json['hushh_id'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> dayTimingsJson = {};
    Map<String, List<Map<String, dynamic>>> selectedSlotsJson = {};
    dayTimings.forEach((key, value) {
      dayTimingsJson[key] = {
        'startTime': _formatTimeOfDay(value.startTime),
        'endTime': _formatTimeOfDay(value.endTime),
      };
    });
    selectedSlots.forEach((key, value) {
      selectedSlotsJson[DateFormat('yyyy-MM-dd').format(key)] = value
          .map((e) => {
                'startTime': _formatTimeOfDay(e.startTime),
                'endTime': _formatTimeOfDay(e.endTime),
              })
          .toList();
    });

    return {
      'isActivated': isActivated,
      'name': name,
      'duration': duration.inMinutes,
      'dayTimings': dayTimingsJson,
      'selectedSlots': selectedSlotsJson,
      'collectPayment': collectPayment,
      'amount': amount,
      'currency': currency,
      'timeZone': timeZone,
      'hushh_id': hushhId,
    };
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  static String _formatTimeOfDay(TimeOfDay timeOfDay) {
    return "${timeOfDay.hour}:${timeOfDay.minute}";
  }

  List<String> generateTimeSlots(context, String day, DateTime selectedDate, userTimeZone) {
    List<String> slots = [];
    TimeRange range = dayTimings[day]!;
    final startTime = Utils().convertTimeOfDayTimeZone(range.startTime, userTimeZone);
    final endTime = Utils().convertTimeOfDayTimeZone(range.endTime, userTimeZone);

    TimeOfDay currentTime = startTime;

    while (currentTime.hour < endTime.hour ||
        (currentTime.hour == endTime.hour &&
            currentTime.minute <= endTime.minute)) {
      TimeOfDay endTimeSlot = TimeOfDay(
        hour: currentTime.hour,
        minute: currentTime.minute + duration.inMinutes,
      );
      if (endTimeSlot.minute >= 60) {
        endTimeSlot = TimeOfDay(
          hour: currentTime.hour + 1,
          minute: endTimeSlot.minute % 60,
        );
      }
      if (!(selectedSlots[DateTime(
                  selectedDate.year, selectedDate.month, selectedDate.day)]
              ?.map((e) => e.toString()).contains(TimeRange(startTime: currentTime, endTime: endTimeSlot).toString()) ??
          false)) {
        slots.add(
            "${MaterialLocalizations.of(context).formatTimeOfDay(currentTime, alwaysUse24HourFormat: true)} - ${MaterialLocalizations.of(context).formatTimeOfDay(endTimeSlot, alwaysUse24HourFormat: true)}");
      }
      currentTime = endTimeSlot;
    }
    return slots;
  }
}
