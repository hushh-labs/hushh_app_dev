import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/share_preferences_bottom_sheet.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

class SharedPreferencesView extends StatelessWidget {
  final bool removeTitle;

  const SharedPreferencesView({super.key, this.removeTitle = false});

  @override
  Widget build(BuildContext context) {
    final controller = sl<CardWalletPageBloc>();
    return BlocListener<CardWalletPageBloc, CardWalletPageState>(
      bloc: controller,
      listener: (context, state) {
        if (state is SharedPreferenceInsertedState) {
          ToastManager(
            Toast(
              title: state.successMessage,
              type: ToastificationType.success,
            ),
          ).show(context);
        }
      },
      child: Padding(
        padding: removeTitle
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
        children: [
          if (!removeTitle)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preferences and needs'.toUpperCase(),
                  style: context.titleSmall?.copyWith(
                    color: const Color(0xFF737373),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const Spacer(),
                Material(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2),
                    child: InkWell(
                      onTap: () => onAdd(controller.cardData, context),
                      child: const Row(
                        children: [
                          Icon(Icons.add, size: 12, color: Color(0xFF737373)),
                          SizedBox(width: 1),
                          Text(
                            'Add',
                            style: TextStyle(
                                color: Color(0xFF737373),
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Icon(Icons.keyboard_arrow_right)
              ],
            ),
          if (!removeTitle) const SizedBox(height: 10),
          BlocBuilder(
              bloc: controller,
              builder: (context, state) {
                final card = controller.cardData;
                if (card == null) return const SizedBox();
                List<UserPreference> prompts =
                    controller.sharedPreferences ?? [];
                return Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(11),
                  child: Container(
                    height: prompts.isEmpty ? 15.h : null,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFD4D4D4)),
                        borderRadius: BorderRadius.circular(10)),
                    child: BlocBuilder(
                        bloc: sl<CardMarketBloc>(),
                        builder: (context, _) {
                          if (prompts.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Transform.scale(
                                    scale: 0.9,
                                    child: ElevatedButton(
                                      onPressed: () => onAdd(card, context),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          foregroundColor: card.primary),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.add),
                                          SizedBox(width: 4),
                                          Text('Add new'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Share your preferences with us',
                                    style: context.bodySmall
                                        ?.copyWith(color: Colors.grey.shade400),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: prompts.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 16),
                                  Text(
                                    prompts![index]
                                        .question
                                        .toUpperCase(),
                                    textAlign: TextAlign.start,
                                    style:
                                    context.bodySmall?.copyWith(
                                      color:
                                      const Color(0xFF737373),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                  SizedBox(
                                    height: prompts[index]
                                        .answers
                                        .isEmpty
                                        ? 30
                                        : prompts[index]
                                        .answers
                                        .first
                                        .toString()
                                        .length >
                                        3 &&
                                        prompts[index]
                                            .answers
                                            .first
                                            .toString()
                                            .substring(
                                            0, 4)
                                            .toLowerCase() ==
                                            "http"
                                        ? prompts[index]
                                        .questionType ==
                                        CardQuestionType
                                            .singleImageUploadQuestion
                                        ? 100
                                        : 50
                                        : 30,
                                    width: 80.w,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection:
                                      Axis.horizontal,
                                      itemCount: prompts[index]
                                          .answers
                                          .length,
                                      separatorBuilder:
                                          (context, i) =>
                                      const Text(' ܂ '),
                                      itemBuilder:
                                          (BuildContext context,
                                          int idx) {
                                        return Center(
                                          child: prompts[index]
                                              .answers[
                                          idx]
                                              .toString()
                                              .length >
                                              3 &&
                                              prompts[index]
                                                  .answers[
                                              idx]
                                                  .toString()
                                                  .substring(
                                                  0, 4)
                                                  .toLowerCase() ==
                                                  "http"
                                              ? Padding(
                                            padding:
                                            const EdgeInsets
                                                .all(4.0),
                                            child: CachedNetworkImage(
                                                imageUrl: prompts[
                                                index]
                                                    .answers[idx]),
                                          )
                                              : Text(
                                            prompts[index]
                                                .answers[idx],
                                            textAlign:
                                            TextAlign
                                                .center,
                                            style: const TextStyle(
                                                color: Colors
                                                    .black,
                                                fontWeight:
                                                FontWeight
                                                    .w600),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (index != prompts.length - 1)
                                    const Divider(
                                      color: Color(0xffE2E2E2),
                                    )
                                ],
                              );
                            },
                          );
                        }),
                  ),
                );
              }),
          const SizedBox(height: 26),
        ],
        ),
      ),
    );
  }

  void onAdd(card, context) async {
    log('🎯 [SHARED_PREFERENCES_VIEW] User clicked Add preference button');
    log('📱 [SHARED_PREFERENCES_VIEW] Card ID: ${card?.id}, Card Name: ${card?.brandName}');
    
    final qA = await showModalBottomSheet(
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) =>
        const SharePreferencesBottomSheet());
        
    if (qA != null) {
      final question = qA.question;
      final answer = qA.answer;
      
      log('📝 [SHARED_PREFERENCES_VIEW] User provided preference data:');
      log('❓ [SHARED_PREFERENCES_VIEW] Question: "$question"');
      log('💭 [SHARED_PREFERENCES_VIEW] Answer: "$answer"');
      log('📄 [SHARED_PREFERENCES_VIEW] Content: "${qA.content}"');
      log('🚀 [SHARED_PREFERENCES_VIEW] Dispatching AddNewPreferenceToCardEvent...');
      
      sl<CardWalletPageBloc>().add(
          AddNewPreferenceToCardEvent(
              cardId: card.id!,
              hushhId:
              AppLocalStorage.hushhId!,
              preference: UserPreference(
                  question: question,
                  answers: [answer],
                  content: qA.content,
                  mandatory: false,
                  questionType:
                  CardQuestionType
                      .textNoteQuestion)));
    } else {
      log('❌ [SHARED_PREFERENCES_VIEW] User cancelled preference addition');
    }
  }
}
