import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/audio_notes.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/delete_audio_prompt_bottomsheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/playable_audio_widget.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewAudioPrompt extends StatelessWidget {
  const NewAudioPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Audio Prompts",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.black),
                      ),
                    ],
                  ),
                  Text("Hit record and express yourself"),
                ],
              ),
              BlocBuilder(
                bloc: sl<CardWalletPageBloc>(),
                builder: (context, state) {
                  if (sl<CardWalletPageBloc>().cardData?.audioUrl != null &&
                      (sl<CardWalletPageBloc>().cardData!.audioUrl!.length > 4
                          ? sl<CardWalletPageBloc>()
                          .cardData!
                          .audioUrl!
                          .substring(0, 4) ==
                          "http"
                          : false)) {
                    return GestureDetector(
                        onTap: () async {
                          final value = await showModalBottomSheet(
                            isDismissible: true,
                            enableDrag: true,
                            backgroundColor: Colors.transparent,
                            constraints: BoxConstraints(maxHeight: 30.h),
                            context: context,
                            builder: (_context) {
                              return DeleteAudioPromptBottomSheet(
                                  onCancel: () {
                                    Navigator.pop(context, false);
                                  },
                                  onDelete: () {
                                    Navigator.pop(context, true);
                                  });
                            },
                          );
                          if (value == true) {
                            sl<CardWalletPageBloc>()
                                .cardData?.audioUrl = null;
                            sl<CardWalletPageBloc>()
                                .audioNotesDuration = null;
                            sl<CardWalletPageBloc>().emit(UpdatingAudioState());
                            await sl<CardWalletPageBloc>()
                                .updateUserInstalledCardUseCase(
                                card: sl<CardWalletPageBloc>().cardData!);
                            sl<CardWalletPageBloc>().emit(AudioUpdatedState());
                          }
                        },
                        child: const Icon(Icons.delete_outline_outlined,
                            color: Colors.red));
                  }

                  return const SizedBox();
                },
              )
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              if (sl<CardWalletPageBloc>().cardData == null) {
                return;
              }
              Navigator.pushNamed(context, AppRoutes.cardMarketPlace.audioNotes,
                  arguments: AudioNotesArgs(
                    isEdit: true,
                    cardData: sl<CardWalletPageBloc>().cardData!,
                    userSelections: [],
                  ));
            },
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                // border: Border.all(color: const Color(0xFF737373)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: PlayableAudioWidget(),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.chevron_right_sharp),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
