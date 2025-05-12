import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/hushh_meet_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_text_field.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/hushh_meet_amount_bottomsheet.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AgentHushhMeet extends StatefulWidget {
  const AgentHushhMeet({super.key});

  @override
  State<AgentHushhMeet> createState() => _AgentHushhMeetState();
}

class _AgentHushhMeetState extends State<AgentHushhMeet> {
  final controller = sl<HushhMeetBloc>();

  @override
  void initState() {
    controller.add(FetchMeetInfoEvent());
    super.initState();
  }

  @override
  void dispose() {
    controller.add(UpdateMeetInfoEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset('assets/back.svg')),
        ),
        actions: [
          BlocBuilder(
              bloc: controller,
              builder: (context, state) {
                return Switch(
                  value: controller.meeting?.isActivated ?? false,
                  onChanged: (value) {
                    if (controller.meeting == null) {
                    } else {
                      controller.meeting!.isActivated = value;
                    }
                    setState(() {});
                  },
                );
              })
        ],
        centerTitle: false,
        title: const Text(
          'HushhMeet Setup',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  AgentTextField(
                    hintText: 'Event name',
                    fieldType: CustomFormType.text,
                    controller: controller.eventNameController,
                  ),
                  AgentTextField(
                    hintText: 'Duration',
                    fieldType: CustomFormType.list,
                    controller: TextEditingController(
                        text: controller.meeting != null
                            ? "${controller.meeting!.duration.inMinutes} minutes"
                            : ""),
                  ),
                  Text(
                    'Set Timings for Each Day',
                    style: context.titleMedium?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.meeting != null
                        ? controller.meeting!.dayTimings.keys.map((day) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    day,
                                    style: context.titleMedium,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: AgentTextField(
                                    controller: TextEditingController(
                                        text:
                                            "${controller.meeting!.dayTimings[day]!.startTime.format(context)} - ${controller.meeting!.dayTimings[day]!.endTime.format(context)}"),
                                    hintText: '',
                                    fieldType: CustomFormType.list,
                                    onTap: () async {
                                      TimeRange? result =
                                          await showTimeRangePicker(
                                              context: context,
                                              start: controller.meeting!
                                                  .dayTimings[day]!.startTime,
                                              end: controller.meeting!
                                                  .dayTimings[day]!.endTime,
                                              disabledTime: TimeRange(
                                                  startTime: const TimeOfDay(
                                                      hour: 22, minute: 0),
                                                  endTime: const TimeOfDay(
                                                      hour: 5, minute: 0)),
                                              disabledColor:
                                                  Colors.red.withOpacity(0.5),
                                              strokeWidth: 4,
                                              ticks: 24,
                                              ticksOffset: -7,
                                              ticksLength: 15,
                                              ticksColor: Colors.grey,
                                              labels: [
                                                "12 am",
                                                "3 am",
                                                "6 am",
                                                "9 am",
                                                "12 pm",
                                                "3 pm",
                                                "6 pm",
                                                "9 pm"
                                              ].asMap().entries.map((e) {
                                                return ClockLabel.fromIndex(
                                                    idx: e.key,
                                                    length: 8,
                                                    text: e.value);
                                              }).toList(),
                                              labelOffset: 35,
                                              rotateLabels: false,
                                              padding: 60);
                                      if (result != null) {
                                        controller.meeting!.dayTimings[day] =
                                            result;
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList()
                        : [],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collect Payments',
                        style: context.titleMedium?.copyWith(fontSize: 18),
                      ),
                      Checkbox(
                          value: controller.meeting?.collectPayment ?? false,
                          onChanged: (value) {
                            if (controller.meeting != null) {
                              if (value != null) {
                                controller.meeting!.collectPayment = value;
                                setState(() {});
                              }
                            }
                          })
                    ],
                  ),
                  if (controller.meeting?.collectPayment ?? false) ...[
                    AgentTextField(
                      controller: TextEditingController(
                          text:
                              "${controller.meeting?.currency ?? ""} ${controller.meeting?.amount ?? 0}"),
                      hintText: 'Amount',
                      textInputType: TextInputType.number,
                      fieldType: CustomFormType.list,
                      onTap: () async {
                        String? amount = await showModalBottomSheet(
                          isDismissible: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          // constraints: BoxConstraints(maxHeight: 36.h),
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: const HushhMeetAmountBottomSheet(),
                            );
                          },
                        );
                        if (amount != null) {
                          controller.meeting!.amount =
                              double.tryParse(amount) ?? 0;
                          setState(() {});
                        }
                      },
                    )
                  ],
                  const SizedBox(height: 100.0),
                ],
              ),
            );
          }),
    );
  }
}
