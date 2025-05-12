import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/hushh_meet_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_text_field.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/customer_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_meeting_location.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/google_calendar.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

class AgentMeetingPage extends StatefulWidget {
  const AgentMeetingPage({super.key});

  @override
  State<AgentMeetingPage> createState() => _AgentMeetingPageState();
}

class _AgentMeetingPageState extends State<AgentMeetingPage> {
  final controller = sl<AgentCardWalletPageBloc>();
  CustomSegmentedController<int> segmentedController =
      CustomSegmentedController(value: 0);
  BorderRadius dynamicBorder = const BorderRadius.only(
    topLeft: Radius.circular(20),
    bottomLeft: Radius.circular(20),
  );
  List<UserModel> participants = [];
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  DateTime dateTime = DateTime.now().add(const Duration(hours: 1));
  Duration duration = const Duration(minutes: 45);
  String? locationName;
  Tuple2<double, double>? location;

  bool get isWalkIn => segmentedController.value == 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Tuple2<Map, String>? data =
          ModalRoute.of(context)!.settings.arguments as Tuple2<Map, String>?;
      if (data != null) {
        String uid = data.item2;
        controller.getUser(uid).then((user) {
          if (user != null) {
            participants.add(user);
            setState(() {});
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Create Meet'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: SizedBox(
            height:
                100.h - kToolbarHeight - MediaQuery.of(context).viewPadding.top,
            child: Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  width: 100.w,
                  child: Center(
                    child: CustomSlidingSegmentedControl<int>(
                      height: 30,
                      controller: segmentedController,
                      fixedWidth: 30.w,
                      children: {
                        0: Text(
                          "Online",
                          style: TextStyle(
                            color: segmentedController.value == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        1: Text(
                          "Walk-in",
                          style: TextStyle(
                            color: segmentedController.value == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      },
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      thumbDecoration: BoxDecoration(
                        borderRadius: dynamicBorder,
                        gradient: const LinearGradient(
                          begin: Alignment(-1.00, 0.05),
                          end: Alignment(1, -0.05),
                          colors: [Color(0xFFE54D60), Color(0xFFA342FF)],
                        ),
                      ),
                      onValueChanged: (int value) {
                        switch (value) {
                          case 0:
                            setState(() {
                              dynamicBorder = const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(0),
                                topRight: Radius.circular(0),
                              );
                            });
                            break;
                          case 1:
                            setState(() {
                              dynamicBorder = const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                              );
                            });
                            break;
                          default:
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                AgentTextField(
                    controller: title,
                    fieldType: CustomFormType.text,
                    hintText: "Meeting title"),
                AgentTextField(
                    controller: description,
                    fieldType: CustomFormType.text,
                    maxLines: 4,
                    hintText: "Description"),
                AgentTextField(
                    controller: TextEditingController(
                        text:
                            DateFormat('dd MMM, yyyy HH:mm').format(dateTime)),
                    fieldType: CustomFormType.dateTime,
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => Container(
                                color: Colors.white,
                                height: 250,
                                child: CupertinoDatePicker(
                                  initialDateTime: dateTime,
                                  onDateTimeChanged: (value) {
                                    dateTime = value;
                                    setState(() {});
                                  },
                                ),
                              ));
                    },
                    hintText: "Meeting date & time"),
                if (!isWalkIn)
                  AgentTextField(
                      fieldType: CustomFormType.duration,
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: StatefulBuilder(
                                      builder: (context, setState) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DurationPicker(
                                        duration: duration,
                                        onChange: (val) {
                                          setState(() => duration = val);
                                        },
                                        snapToMins: 5.0,
                                      ),
                                    );
                                  }),
                                ));
                        setState(() {});
                      },
                      controller: TextEditingController(
                          text: duration.inHours != 0
                              ? "${duration.inHours} hrs ${duration.inMinutes.remainder(60)} mins"
                              : "${duration.inMinutes.remainder(60)} mins"),
                      hintText: "Duration"),
                if (isWalkIn) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 20.h,
                    child: InkWell(
                      onTap: () async {
                        LatLng? latLng = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AgentMeetingLocation()));
                        if(latLng != null) {
                          location = Tuple2<double, double>(latLng.latitude, latLng.longitude);
                          List<Placemark> placemarks = await placemarkFromCoordinates(
                              latLng.latitude, latLng.longitude);
                          if(placemarks.isNotEmpty) {
                            locationName = placemarks.first.name;
                          }
                          setState(() {});
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        strokeWidth: 1,
                        dashPattern: const [8],
                        color: const Color(0xFF4A789C),
                        radius: const Radius.circular(8),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_box_outlined,
                                      color: Color(0xFF4A789C)),
                                  SizedBox(width: 4),
                                  Text(
                                    'UPLOAD',
                                    style: TextStyle(color: Color(0xFF4A789C)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Meeting Location \n ${locationName ?? ''}',
                                    style: context.titleMedium?.copyWith(
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16)
                ],
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add Participants"),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: List.generate(
                        participants.length,
                        (index) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      (participants[index].avatar != null &&
                                                  (participants[index]
                                                          .avatar
                                                          ?.isNotEmpty ??
                                                      false)
                                              ? CachedNetworkImageProvider(
                                                  participants[index].avatar!)
                                              : const ExactAssetImage(
                                                  'assets/user.png'))
                                          as ImageProvider,
                                ),
                                Text(participants[index].name?.capitalize() ??
                                    "")
                              ],
                            ))
                      ..add(Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          onTap: () async {
                            List<CustomerModel>? selectedCustomers =
                                await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    constraints:
                                        BoxConstraints(maxHeight: 80.h),
                                    builder: (context) => CustomerListView(
                                        customers: sl<AgentCardWalletPageBloc>()
                                            .customers!
                                            .where((element) => ((element
                                                        .brand.accessList ??
                                                    [])
                                                .contains(
                                                    AppLocalStorage.hushhId)))
                                            .toList(),
                                        selectedUsers: participants,
                                        isEdit: true));

                            if (selectedCustomers != null) {
                              participants =
                                  selectedCustomers.map((e) => e.user).toList();
                              setState(() {});
                            }
                          },
                          child: const Icon(
                            Icons.add_circle_outline_sharp,
                            size: 40,
                          ),
                        ),
                      )),
                  ),
                ),
                const Spacer(),
                BlocBuilder(
                    bloc: sl<AgentCardWalletPageBloc>(),
                    builder: (context, state) {
                      return InkWell(
                        onTap: () async {
                          if (title.text.trim().isEmpty ||
                              description.text.trim().isEmpty ||
                              participants.isEmpty) {
                            ToastManager(Toast(
                                    title:
                                        'Please enter the text, description & select at least one participant',
                                    type: ToastificationType.error))
                                .show(context);
                            return;
                          }
                          if (state != CreatingNewMeetingState) {
                            List<UserModel> newParticipants =
                                List<UserModel>.from(participants);
                            newParticipants.add(sl<CardWalletPageBloc>().user!);
                            Tuple2<String?, String?>? googleMeetData =
                                await GoogleCalendar.insert(
                              title: title.text,
                              description: description.text,
                              location: locationName ?? 'Google Meet: Online',
                              attendeeEmailList: newParticipants
                                  .map((e) => cal.EventAttendee(
                                      email: e.email,
                                      id: e.hushhId,
                                      displayName: e.name,
                                      organizer:
                                          e.hushhId == AppLocalStorage.hushhId,
                                      self:
                                          e.hushhId == AppLocalStorage.hushhId))
                                  .toList(),
                              shouldNotifyAttendees: true,
                              hasConferenceSupport: !isWalkIn,
                              startTime: dateTime,
                              endTime: dateTime.add(duration),
                            );
                            final meeting = MeetingModel(
                                id: const Uuid().v4(),
                                title: title.text,
                                desc: description.text,
                                dateTime: dateTime,
                                organizerId:
                                    sl<CardWalletPageBloc>().user!.hushhId!,
                                duration: isWalkIn ? null : duration,
                                lat: isWalkIn ? 0 : null,
                                long: isWalkIn ? 0 : null,
                                participantsIds: participants
                                    .map((e) => e.hushhId!)
                                    .toList(),
                                meetingType: isWalkIn
                                    ? MeetingType.walkIn
                                    : MeetingType.online,
                                gEventId:
                                    isWalkIn ? null : googleMeetData?.item1,
                                gMeetLink:
                                    isWalkIn ? null : googleMeetData?.item2);
                            sl<HushhMeetBloc>()
                                .add(CreateMeetingEvent(meeting, context));
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.96, vertical: 13.09),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(-1.00, 0.05),
                              end: Alignment(1, -0.05),
                              colors: [
                                Color(0xFFA342FF),
                                Color(0xFFE54D60),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(67),
                            ),
                          ),
                          child: state is CreatingNewMeetingState
                              ? const Center(
                                  child: SizedBox.square(
                                      dimension: 16,
                                      child: CircularProgressIndicator()),
                                )
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create meeting',
                                      style: TextStyle(
                                        color: Color(0xFFF6F6F6),
                                        fontSize: 14,
                                        fontFamily: 'Figtree',
                                        fontWeight: FontWeight.w700,
                                        height: 1,
                                        letterSpacing: 0.20,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
