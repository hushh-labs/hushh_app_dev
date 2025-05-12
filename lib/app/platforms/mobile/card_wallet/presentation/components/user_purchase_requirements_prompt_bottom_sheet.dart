import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/splash/presentation/bloc/splash_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserPurchaseRequirementsPromptBottomSheet extends StatefulWidget {
  final int brandId;
  final int? cardId;

  const UserPurchaseRequirementsPromptBottomSheet(
      {super.key, required this.brandId, this.cardId});

  @override
  State<UserPurchaseRequirementsPromptBottomSheet> createState() =>
      _UserPurchaseRequirementsPromptBottomSheetState();
}

class _UserPurchaseRequirementsPromptBottomSheetState
    extends State<UserPurchaseRequirementsPromptBottomSheet> {
  late final RecorderController recorderController;
  TextEditingController textController = TextEditingController();
  bool isRecording = false;
  bool isRecordingComplete = false;
  String? lastRecordedPath;

  @override
  void dispose() {
    if (isRecording) {
      recorderController.reset();
      recorderController
          .stop(false)
          .then((value) => recorderController.dispose());
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initialiseControllers();
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'What are you looking for today?',
                style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 20,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                        color: Color(0xFF4C4C4C), fontFamily: 'Figtree'),
                    children: [
                      TextSpan(
                        text:
                            'Tell us what you\'re here for—whether it’s exploring new products, picking up an order, or getting expert help, we\'re here for you!',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 20.w,
                child: Divider(
                  color: const Color(0xFF50555C).withOpacity(0.2),
                ),
              ),
              const SizedBox(height: 16),
              isRecording || isRecordingComplete
                  ? Row(
                      children: [
                        Expanded(
                          child: AudioWaveforms(
                            enableGesture: true,
                            size:
                                Size(MediaQuery.of(context).size.width / 2, 50),
                            recorderController: recorderController,
                            waveStyle: const WaveStyle(
                              waveColor: Colors.white,
                              extendWaveform: true,
                              showMiddleLine: false,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: const Color(0xFF1E1B26),
                            ),
                            padding: const EdgeInsets.only(left: 18),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                          ),
                        ),
                        if (isRecordingComplete)
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  recorderController.reset();
                                  _startOrStopRecording();
                                },
                                child: const Icon(
                                  IonIcons.refresh_circle,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () async {
                                  recorderController.reset();
                                  await recorderController.stop(false);
                                  isRecording = false;
                                  isRecordingComplete = false;
                                  lastRecordedPath = null;
                                  setState(() {});
                                },
                                child: const Icon(
                                  IonIcons.close_circle,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        else
                          GestureDetector(
                            onTap: _startOrStopRecording,
                            child: const Icon(
                              IonIcons.stop_circle,
                              color: Colors.black,
                            ),
                          ),
                        const SizedBox(width: 8),
                      ],
                    )
                  : CustomTextField(
                      edgeInsets: EdgeInsets.zero,
                      controller: textController,
                      trailing: GestureDetector(
                        onTap: _startOrStopRecording,
                        child: const Icon(
                          IonIcons.mic_circle,
                          color: Colors.black,
                        ),
                      ),
                      hintText: 'eg. picking up an iphone 16',
                      showPrefix: false,
                    ),
              const SizedBox(height: 16),
              SizedBox(
                height: 46,
                child: BlocBuilder(
                    bloc: sl<SplashPageBloc>(),
                    builder: (context, state) {
                      return HushhLinearGradientButton(
                        text: 'Notify the Agents',
                        radius: 12,
                        color: Colors.black,
                        enabled: isRecordingComplete ||
                            textController.text.trim().isNotEmpty,
                        loader: state
                            is SharingUserProfileAndRequirementsWithAgentsState,
                        onTap: () async {
                          if (widget.cardId == null) {
                            ToastManager(Toast(
                                    title:
                                        'Please add the brand card in your wallet'))
                                .show(context);
                            return;
                          }
                          ToastManager(Toast(
                                  title:
                                      'Thanks for providing your requirements!',
                                  duration: const Duration(seconds: 5),
                                  description:
                                      'Please reach the store while we are informing the agents about your visit.'))
                              .show(context);
                          String text = textController.text;
                          sl<SplashPageBloc>().add(
                              ShareUserProfileAndRequirementsWithAgentsEvent(
                            userId: AppLocalStorage.hushhId!,
                            query: text,
                            context: context,
                            brandId: widget.brandId,
                            cardId: widget.cardId!,
                            audioPath: lastRecordedPath,
                          ));
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _startOrStopRecording() async {
    isRecordingComplete = false;
    try {
      if (isRecording) {
        final path = await recorderController.stop(false);

        if (path != null) {
          debugPrint(path);
          isRecordingComplete = true;
          lastRecordedPath = path;
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }
      } else {
        await recorderController.record();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (recorderController.hasPermission) {
        setState(() {
          isRecording = !isRecording;
        });
      }
    }
  }
}
