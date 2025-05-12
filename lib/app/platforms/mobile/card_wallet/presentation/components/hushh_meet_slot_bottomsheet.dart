import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/hushh_meet_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class HushhMeetSlotBottomSheet extends StatefulWidget {
  final String day;
  final DateTime selectedDate;

  const HushhMeetSlotBottomSheet(
      {super.key, required this.day, required this.selectedDate});

  @override
  State<HushhMeetSlotBottomSheet> createState() =>
      _HushhMeetSlotBottomSheetState();
}

class _HushhMeetSlotBottomSheetState extends State<HushhMeetSlotBottomSheet> {
  TextEditingController controller = TextEditingController();
  List<String>? slots;
  int? selectedIndex;
  String? userTimeZone;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      userTimeZone = await FlutterNativeTimezone.getLocalTimezone();
      userTimeZone = userTimeZone?.replaceAll('Asia/Calcutta', 'Asia/Kolkata');
      slots = sl<HushhMeetBloc>()
          .meeting!
          .generateTimeSlots(context, widget.day, widget.selectedDate, userTimeZone);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Times',
                    style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 20,
                        letterSpacing: -0.4,
                        fontWeight: FontWeight.w600),
                  ),
                  FutureBuilder(
                      future: FlutterNativeTimezone.getLocalTimezone(),
                      builder: (context, state) {
                        if (state.data != null) {
                          return Text(
                            state.data!,
                            style: const TextStyle(
                                fontFamily: 'Figtree', fontSize: 14),
                          );
                        }
                        return const SizedBox();
                      }),
                ],
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFEAE4D9),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  size: 18,
                ),
              )
            ],
          ),
          const Divider(
            color: Color(0xFF50555C),
          ),
          const SizedBox(height: 8),
          if (slots != null)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    slots!.length,
                    (index) => Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                foregroundColor: Colors.black,
                                backgroundColor:
                                    CupertinoColors.extraLightBackgroundGray),
                            onPressed: () {
                              selectedIndex = index;
                              setState(() {});
                            },
                            child: Text(slots![index]),
                          ),
                        ),
                        if (selectedIndex == index) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFFE51A5E)),
                              onPressed: () async {
                                String selectedSlot = slots![index];
                                sl<HushhMeetBloc>().add(UserConfirmMeetEvent(
                                    selectedSlot,
                                    context,
                                    widget.selectedDate));
                              },
                              child: const Text("Confirm"),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
