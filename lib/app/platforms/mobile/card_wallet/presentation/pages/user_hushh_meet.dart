import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/hushh_meet_slot_bottomsheet.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class UserHushhMeet extends StatefulWidget {
  const UserHushhMeet({super.key});

  @override
  State<UserHushhMeet> createState() => _UserHushhMeetState();
}

class _UserHushhMeetState extends State<UserHushhMeet> {
  final months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  final days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  final timesAvailable = ["9:00am", "10:00am", "11:00am", "2:00pm", "3:00pm"];

  String selectedEvent = "Pricing Review"; // Default event name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Date & Time'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SfCalendar(
          view: CalendarView.month,
          showDatePickerButton: true,
          todayHighlightColor: const Color(0xFFE51A5E),
          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: const Color(0xFFE51A5E)),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            shape: BoxShape.rectangle,
          ),
          onTap: (CalendarTapDetails details) async {
            DateTime selectedDate = details.date!;
            DateTime currentDate = DateTime.now();
            if (selectedDate.isAfter(currentDate)) {
              showModalBottomSheet(
                isDismissible: true,
                enableDrag: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                constraints: BoxConstraints(maxHeight: 50.h),
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: HushhMeetSlotBottomSheet(
                        selectedDate: selectedDate,
                        day: DateFormat('EEEE').format(selectedDate)),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _navigateToRegister(DateTime selectedDate, String selectedTime) {
    String selectedDateString =
        "${days[selectedDate.weekday - 1]}, ${months[selectedDate.month - 1]} ${selectedDate.day}";
    Map<String, dynamic> event = {
      "name": selectedEvent,
      "organizer": "ACME Sales",
      "duration": 15, // Assuming the duration is fixed for all events
      "description": "Our team will meet with you to review pricing options.",
      "date": selectedDateString,
      "time": selectedTime,
    };
    // Navigate to registration page with event details
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage(event: event)),
    );
  }
}

class RegisterPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const RegisterPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Event Details",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Text("Event: ${event['name']}"),
              Text("Organizer: ${event['organizer']}"),
              Text("Duration: ${event['duration']} min"),
              Text("Date: ${event['date']}"),
              Text("Time: ${event['time']}"),
              const SizedBox(height: 20.0),
              // Add registration form fields here
            ],
          ),
        ),
      ),
    );
  }
}
