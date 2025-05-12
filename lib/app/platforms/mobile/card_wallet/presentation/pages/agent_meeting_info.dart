import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/hushh_meet_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/delete_meeting_bottomsheet.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AgentMeetingInfoPage extends StatelessWidget {
  const AgentMeetingInfoPage({super.key});

  String formatDateTime(DateTime dateTime, Duration? duration) {
    final DateFormat dateFormat = DateFormat('E, MMM d, y · h:mm a');
    final String formattedDate = dateFormat.format(dateTime);

    // Assuming the event duration is one hour
    final String endTime = DateFormat('h:mm a')
        .format(dateTime.add(duration ?? const Duration(hours: 1)));

    return '$formattedDate - $endTime';
  }

  @override
  Widget build(BuildContext context) {
    final meeting = ModalRoute.of(context)!.settings.arguments as MeetingModel;
    final participants = sl<AgentCardWalletPageBloc>()
        .customers?.where((element) =>
            ((element.brand.accessList ?? []).contains(AppLocalStorage.hushhId)) &&
            (meeting.participantsIds.contains(element.user.hushhId)))
        .toList() ?? [];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Meeting Details'),
        actions: [
          if (meeting.organizerId == sl<CardWalletPageBloc>().user!.hushhId!)
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    isDismissible: true,
                    enableDrag: true,
                    backgroundColor: Colors.transparent,
                    constraints: BoxConstraints(maxHeight: 30.h),
                    context: context,
                    builder: (_) {
                      return DeleteMeetingBottomSheet(onCancel: () {
                        Navigator.pop(context);
                      }, onDelete: () {
                        sl<HushhMeetBloc>()
                            .add(DeleteMeetingEvent(meeting, context));
                        Navigator.pop(context);
                      });
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: InkWell(
          onTap: () {
            if (meeting.meetingType == MeetingType.walkIn) {
              launchUrl(Uri.parse(
                  'https://maps.google.com/?q=47.612277327025815,-122.33635108913933'));
            } else {
              launchUrl(Uri.parse('https://meet.google.com'));
              // if (meet.gMeetLink != null) {
              //   launchUrl(Uri.parse(meet.gMeetLink!));
              // } else {
              //   ToastManager(Toast(
              //           title:
              //               'No meeting found! Please contact the organizer.',
              //           type: ToastificationType.error))
              //       .show(context);
              // }
            }
          },
          child: Container(
            width: double.infinity,
            height: 48.63,
            padding:
                const EdgeInsets.symmetric(horizontal: 14.96, vertical: 13.09),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  meeting.meetingType == MeetingType.walkIn
                      ? 'Navigate to 📍'
                      : 'Join Now',
                  style: const TextStyle(
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
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  meeting.title,
                  style:
                      context.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Text(formatDateTime(meeting.dateTime, meeting.duration)),
              ],
            ),
          ),
          const Divider(),
          // SizedBox(height: 12),
          // Container(
          //   padding: EdgeInsets.all(16),
          //   width: double.infinity,
          //   color: Color(0xFFF7FAFC),
          //   child: Row(
          //     children: [
          //       Text('Edit Timings'),
          //     ],
          //   ),
          // ),
          if(participants.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Participants',
                    style: context.titleSmall,
                  ),
                  const SizedBox(height: 16),
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
                                backgroundImage: (participants[index]
                                    .user
                                    .avatar !=
                                    null &&
                                    (participants[index]
                                        .user
                                        .avatar
                                        ?.isNotEmpty ??
                                        false)
                                    ? CachedNetworkImageProvider(
                                    participants[index].user.avatar!)
                                    : const ExactAssetImage(
                                    'assets/user.png')) as ImageProvider,
                              ),
                              const SizedBox(height: 4),
                              Text(participants[index]
                                  .user
                                  .name
                                  ?.capitalize() ??
                                  "")
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
          // SizedBox(height: 12),
          // Container(
          //   padding: EdgeInsets.all(16),
          //   width: double.infinity,
          //   color: Color(0xFFF7FAFC),
          //   child: Row(
          //     children: [
          //       Text('Add participants'),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: context.titleSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  meeting.desc,
                  style: const TextStyle(color: Color(0xFF4F7396)),
                ),
                const SizedBox(height: 16),
                Text(
                  'Location',
                  style: context.titleSmall,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Not provided",
                  style: TextStyle(color: Color(0xFF4F7396)),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ParticipantImage extends StatelessWidget {
  const ParticipantImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundImage: NetworkImage(
          "https://s3-alpha-sig.figma.com/img/0012/ee84/9280ef030cd82546db6787967a3aa28f?Expires=1711929600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=RzwcFIXmF21HsjN1tUEY7MjvI2i0jlhMOyt9q4zLwl02Qaf-c1GWj3Z8zjAYu1TV0L1R-M~hOQdAOOkuiphBQgTDjYsigBD3uer-v0RV4aceYq6Cbjcfaa9zmpQbrCSZEwCLCiBRvLSz4fZXFg14oq~PRdEyieBzyyIP9uaMz0wBxJQQ52bsu21AVmdtQ2wTAs4tR8XhZNFmPxNaMEvGASDD9uNoSmsPsV~7VtTcBnw4Jto7qdMeDzhES7tnv9h-aLRV~Qdqh4DkIXxJi62qzus6ysCF8Rpq79--v~SJ-jm~qVaz~gRAINkgS-nmqafq4DxAl~9v3LdfkPdnl5qgzQ__"),
    );
  }
}
