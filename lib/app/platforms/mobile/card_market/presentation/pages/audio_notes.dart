import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/card_bid_value.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

class AudioNotesArgs {
  final CardModel cardData;
  final List<UserPreference> userSelections;
  final bool isEdit;

  AudioNotesArgs({
    required this.cardData,
    required this.userSelections,
    this.isEdit = false,
  });
}

class AudioNotes extends StatefulWidget {
  AudioNotes();

  @override
  State<AudioNotes> createState() => _AudioNotesState();
}

class _AudioNotesState extends State<AudioNotes> with TickerProviderStateMixin {
  String minimumBid = '';
  final double recordButtonLockerHeight = 200;
  double recordButtonTimerWidth = 0;
  DateTime? recordButtonStartTime;
  Timer? recordButtonTimer;
  String recordButtonRecordDuration = "00:00";
  String recordString = "Record";
  final _audioRecorder = AudioRecorder();
  bool recordButtonIsLocked = false;
  bool recordButtonShowLottie = false;
  int recordButtonMessageIdLocal = 0;
  AnimationController? audioController;
  FocusNode focusNode = FocusNode();
  String urlThumbnailTemp = "";
  firebase_storage.FirebaseStorage storageInc =
      firebase_storage.FirebaseStorage.instanceFor(
          bucket: "gs://hushone-app.appspot.com");
  AnimationController? _controller;
  bool saveLoading = false;
  Duration duration = Duration.zero;
  String? _recordedFilePath;

  AudioPlayer get audioPlayerLoader => sl<CardWalletPageBloc>().audioPlayerLoader;

  Duration? get audioNotesDuration => sl<CardWalletPageBloc>().audioNotesDuration;

  void updateAudioDuration(audioUrl) {
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

  insertAudioMessage() async {
    Directory tempDir = await getTemporaryDirectory();
    final args = ModalRoute.of(context)!.settings.arguments as AudioNotesArgs;
    Reference refThumbnail = storageInc.ref().child(
        "user/audios/${args.cardData.id}/audio_$recordButtonMessageIdLocal.m4a");
    UploadTask uploadTaskThumbnail = refThumbnail
        .putFile(File("${tempDir.path}/audio_$recordButtonMessageIdLocal.m4a"));
    urlThumbnailTemp =
        await (await uploadTaskThumbnail.whenComplete(() => null))
            .ref
            .getDownloadURL();
    setState(() {});
    if (urlThumbnailTemp.isNotEmpty) {
      sl<CardWalletPageBloc>().emit(UpdatingAudioState());
      sl<CardWalletPageBloc>().cardData = sl<CardWalletPageBloc>()
          .cardData
          ?.copyWith(audioUrl: urlThumbnailTemp);
      await sl<CardWalletPageBloc>().updateUserInstalledCardUseCase(card: sl<CardWalletPageBloc>().cardData!);
      sl<CardWalletPageBloc>().add(CardWalletInitializeEvent(context, refresh: true));
      sl<CardWalletPageBloc>().emit(AudioUpdatedState());
      ToastManager(
        Toast(
          title: "Audio saved",
          type: ToastificationType.info,
        ),
      ).show(context);
      audioPlayerLoader!
          .setFilePath("${tempDir.path}/audio_$recordButtonMessageIdLocal.m4a")
          .then((value) {
        updateAudioDuration(urlThumbnailTemp);
        duration = value!;
        setState(() {});
      });
    }
    setState(() {
      saveLoading = false;
      recordString = "Play";
    });
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(150 * _controller!.value),
            _buildContainer(200 * _controller!.value),
            Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                  color: const Color(0xff118CFD),
                  borderRadius: BorderRadius.circular(50)),
              child: const Center(
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(1 - _controller!.value),
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        _recordedFilePath = "${tempDir.path}/audio_$recordButtonMessageIdLocal.m4a";
        
        await _audioRecorder.start(
          RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
            numChannels: 2,
          ),
          path: _recordedFilePath!,
        );

        recordButtonStartTime = DateTime.now();
        recordButtonTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (recordButtonStartTime != null) {
            final now = DateTime.now();
            final difference = now.difference(recordButtonStartTime!);
            setState(() {
              recordButtonRecordDuration = prettyDuration(difference);
            });
          }
        });
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      recordButtonTimer?.cancel();
      if (_recordedFilePath != null) {
        await insertAudioMessage();
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _controller?.dispose();
    audioController?.dispose();
    recordButtonTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 3),
    );
    audioController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    audioController!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return min + ":" + sec;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as AudioNotesArgs;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey)),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: const Text(
          'Audio notes',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Figtree',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        padding:
            const EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 12.h),
                const Text(
                  'Attach audio notes\nwith the card',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontFamily: 'Figtree',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    Container(
                      width: 125,
                      height: 125,
                      child: _buildBody(),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "click the record button and share your\nrequirements.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    recordString == "Play"
                        ? prettyDuration(duration)
                        : recordButtonRecordDuration,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                recordString = "Record";
                              });
                              Directory tempDir = await getTemporaryDirectory();
                              File("${tempDir.path}/audio_$recordButtonMessageIdLocal.m4a")
                                  .deleteSync();
                              _controller!.stop();
                              ToastManager(
                                Toast(
                                  title: 'Reset completed',
                                  type: ToastificationType.info,
                                ),
                              ).show(context);
                            },
                            child: Image.asset(
                              "assets/cancel_record.png",
                              width: 32,
                              height: 32,
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          InkWell(
                            onTap: () async {
                              if (recordString == "Record") {
                                _controller!.repeat();
                                setState(() {
                                  recordString = "Stop";
                                });
                                await _startRecording();
                              } else if (recordString == "Stop") {
                                setState(() {
                                  _controller!.stop();
                                  saveLoading = true;
                                });
                                focusNode.unfocus();
                                audioController!.reverse();
                                await _stopRecording();
                              }
                            },
                            child: saveLoading
                                ? Container(
                              width: 7.h,
                              height: 7.h,
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
                                  borderRadius: BorderRadius.circular(65),
                                ),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                                : recordString == "Play"
                                ? StreamBuilder<PlayerState>(
                              stream: audioPlayerLoader!.playerStateStream,
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
                                    onTap: audioPlayerLoader!.play,
                                    child: Container(
                                      width: 7.h,
                                      height: 7.h,
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
                                    onTap: audioPlayerLoader!.play,
                                    child: Container(
                                      width: 7.h,
                                      height: 7.h,
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
                                    child: Container(
                                      width: 7.h,
                                      height: 7.h,
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
                                          borderRadius:
                                          BorderRadius.circular(65),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.pause,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: audioPlayerLoader!.pause,
                                  );
                                } else {
                                  return GestureDetector(
                                    child: Container(
                                      width: 7.h,
                                      height: 7.h,
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
                                      audioPlayerLoader!
                                          .seek(Duration.zero);
                                    },
                                  );
                                }
                              },
                            )
                                : Container(
                              width: 7.h,
                              height: 7.h,
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
                                  borderRadius: BorderRadius.circular(65),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  recordString,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: 'Figtree',
                                    fontWeight: FontWeight.w700,
                                    height: 1,
                                    letterSpacing: 0.20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          InkWell(
                            onTap: () {
                              if (args.isEdit) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushNamed(
                                    context, AppRoutes.cardMarketPlace.cardValue,
                                    arguments: CardValueArgs(
                                        audioValue: urlThumbnailTemp,
                                        cardData: args.cardData,
                                        userSelections: args.userSelections));
                              }
                            },
                            child: Image.asset(
                              "assets/send_record.png",
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!args.isEdit)
                    Expanded(
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.cardMarketPlace.cardValue,
                                arguments: CardValueArgs(
                                    audioValue: urlThumbnailTemp,
                                    cardData: args.cardData,
                                    userSelections: args.userSelections));
                          },
                          child: const Center(
                            child: Text(
                              'Skip',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF717174),
                                fontSize: 14,
                                fontFamily: 'Figtree',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
