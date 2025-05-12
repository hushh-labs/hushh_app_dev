import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PlayableAudioWidget extends StatefulWidget {
  const PlayableAudioWidget({super.key});

  @override
  State<PlayableAudioWidget> createState() => _PlayableAudioWidgetState();
}

class _PlayableAudioWidgetState extends State<PlayableAudioWidget> {
  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return "$min:$sec";
  }

  String? audioUrl = sl<CardWalletPageBloc>().cardData?.audioUrl;

  AudioPlayer get audioPlayerLoader => sl<CardWalletPageBloc>().audioPlayerLoader;

  Duration? get audioNotesDuration => sl<CardWalletPageBloc>().audioNotesDuration;

  void updateAudioDuration() {
    if (audioUrl != null) {
      if (audioUrl!.isNotEmpty && !audioUrl!.contains('#')) {
        audioPlayerLoader.setUrl(audioUrl!).then((value) async {
          sl<CardWalletPageBloc>().audioNotesDuration = value!;
          audioPlayerLoader.pause();
          setState(() {});
        });
      }
    }
  }

  @override
  void initState() {
    updateAudioDuration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: sl<CardWalletPageBloc>(),
      builder: (context, state) {
        return audioUrl != null &&
            audioNotesDuration != null &&
            (audioUrl!.length > 4 ? audioUrl!.substring(0, 4) == "http" : false)
            ? Container(
          width: 60.w,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
          ),
          child: StreamBuilder<Duration>(
              stream: audioPlayerLoader.positionStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      StreamBuilder<PlayerState>(
                        stream: audioPlayerLoader.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState =
                              playerState?.processingState;
                          final playing = playerState?.playing;
                          if (processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering) {
                            return GestureDetector(
                              onTap: audioPlayerLoader.play,
                              child: Container(
                                width: 4.h,
                                height: 4.h,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF5865F2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(65),
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
                                    borderRadius: BorderRadius.circular(65),
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
                                    borderRadius: BorderRadius.circular(65),
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
                                    borderRadius: BorderRadius.circular(65),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.replay,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                audioPlayerLoader.seek(Duration.zero);
                              },
                            );
                          }
                        },
                      ),
                      Container(
                        width: 35.w,
                        height: 4.h,
                        foregroundDecoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/wave_o.png"),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                              Color(0xFFF2F2F2),
                              BlendMode.srcATop,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: LinearProgressIndicator(
                            value: audioNotesDuration == Duration.zero
                                ? 0
                                : snapshot.data!.inMilliseconds /
                                (audioNotesDuration!.inMilliseconds),
                            color: Colors.black,
                            backgroundColor: const Color(0xffEDEDED),
                          ),
                        ),
                      ),
                      Text(
                        prettyDuration(snapshot.data! == Duration.zero
                            ? audioNotesDuration!
                            : snapshot.data!),
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black),
                      ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              }),
        )
            : const Text('Record a new Prompt');
      },
    );
  }
}
