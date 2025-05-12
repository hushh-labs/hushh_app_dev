import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/countriesModel.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserBasicInfoSection extends StatefulWidget {
  final UserModel user;
  final bool haveAccess;
  final CustomerModel customer;

  const UserBasicInfoSection({
    super.key,
    required this.user,
    required this.haveAccess,
    required this.customer,
  });

  @override
  State<UserBasicInfoSection> createState() => _UserBasicInfoSectionState();
}

class _UserBasicInfoSectionState extends State<UserBasicInfoSection> {
  AudioPlayer audioPlayerLoader = AudioPlayer();
  Duration? audioNotesDuration;

  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return "$min:$sec";
  }

  loadAudio() async {
    if (widget.customer.brand.audioUrl?.isNotEmpty ?? false) {
      if (!widget.customer.brand.audioUrl!.contains('#')) {
        await audioPlayerLoader
            .setUrl(widget.customer.brand.audioUrl!)
            .then((value) {
          audioNotesDuration = value!;
        });
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    loadAudio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Country? country = countries
        .where((element) => element.dialCode == widget.user.countryCode)
        .firstOrNull;
    final address = country?.name ?? '-';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: Column(
        children: [
          Row(
            children: [
              BasicInfo(
                  title: "Age",
                  desc: widget.user.dob?.calculateAge().toString() ?? "-",
                  dummy: '20',
                  haveAccess: widget.haveAccess),
              BasicInfo(
                  title: "Gender",
                  desc: widget.user.gender ?? "-",
                  dummy: 'Male',
                  haveAccess: widget.haveAccess),
              BasicInfo(
                  title: "Address",
                  desc: address,
                  dummy: 'Seattle',
                  haveAccess: widget.haveAccess),
            ],
          ),
          (widget.customer.brand.audioUrl != null && audioNotesDuration != null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        width: 60.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F7F8),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: StreamBuilder<Duration>(
                            stream: audioPlayerLoader.positionStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Row(
                                  children: [
                                    StreamBuilder<PlayerState>(
                                      stream:
                                          audioPlayerLoader.playerStateStream,
                                      builder: (context, snapshot) {
                                        final playerState = snapshot.data;
                                        final processingState =
                                            playerState?.processingState;
                                        final playing = playerState?.playing;
                                        if (processingState ==
                                                ProcessingState.loading ||
                                            processingState ==
                                                ProcessingState.buffering) {
                                          return GestureDetector(
                                            onTap: audioPlayerLoader.play,
                                            child: Container(
                                              width: 4.h,
                                              height: 4.h,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF5865F2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(65),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        } else if (playing != true) {
                                          return GestureDetector(
                                            onTap: audioPlayerLoader.play,
                                            child: Container(
                                              width: 4.h,
                                              height: 4.h,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF5865F2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(65),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        } else if (processingState !=
                                            ProcessingState.completed) {
                                          return GestureDetector(
                                            onTap: audioPlayerLoader.pause,
                                            child: Container(
                                              width: 4.h,
                                              height: 4.h,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF5865F2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(65),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.pause,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return GestureDetector(
                                            child: Container(
                                              width: 4.h,
                                              height: 4.h,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF5865F2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(65),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.replay,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              audioPlayerLoader
                                                  .seek(Duration.zero);
                                            },
                                          );
                                        }
                                      },
                                    ),
                                    Container(
                                      width: 35.w,
                                      height: 7.h,
                                      foregroundDecoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage("assets/wave_o.png"),
                                          fit: BoxFit.fill,
                                          colorFilter: ColorFilter.mode(
                                            Color(0xFFF6F7F8),
                                            BlendMode.srcATop,
                                          ),
                                        ),
                                      ),
                                      child: LinearProgressIndicator(
                                        value: audioNotesDuration ==
                                                Duration.zero
                                            ? 0
                                            : snapshot.data!.inMilliseconds /
                                                (audioNotesDuration!
                                                    .inMilliseconds),
                                        color: Colors.black,
                                        backgroundColor:
                                            const Color(0xffEDEDED),
                                      ),
                                    ),
                                    Text(
                                      prettyDuration(
                                          snapshot.data! == Duration.zero
                                              ? audioNotesDuration!
                                              : snapshot.data!),
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.black),
                                    ),
                                  ],
                                );
                              } else {
                                return const LinearProgressIndicator();
                              }
                            }),
                      ).toBlur(widget.haveAccess),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class BasicInfo extends StatelessWidget {
  final String title;
  final String dummy;
  final String desc;
  final bool haveAccess;

  const BasicInfo(
      {super.key,
      required this.title,
      required this.desc,
      required this.haveAccess,
      required this.dummy});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(title),
          Text(!haveAccess?dummy:desc,
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              )).toBlur(!haveAccess),
        ],
      ),
    );
  }
}
