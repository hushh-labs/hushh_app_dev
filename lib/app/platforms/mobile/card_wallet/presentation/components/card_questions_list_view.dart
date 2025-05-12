import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_questions_common_widgets.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/edit_card_questions.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CardQuestionsListView extends StatelessWidget {
  final bool removeTitle;

  const CardQuestionsListView({super.key, this.removeTitle = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: sl<CardWalletPageBloc>(),
        builder: (context, state) {
          final card = sl<CardWalletPageBloc>().cardData;
          List<UserPreference>? prompts = card?.brandPreferences
              .where((element) =>
                  element.questionType != CardQuestionType.imageSwipeQuestion &&
                  element.questionType !=
                      CardQuestionType.multiImageUploadQuestion)
              .toList();
          UserPreference? swipeCardsPreference = prompts
              ?.where((element) =>
                  element.questionType == CardQuestionType.imageSwipeQuestion)
              .firstOrNull;
          if ((prompts?.length ?? 0) == 0) {
            return const SizedBox();
          }
          return Padding(
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
                        'brand preferences'.toUpperCase(),
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
                            onTap: () {},
                            child: const Row(
                              children: [
                                Icon(Icons.edit,
                                    size: 12, color: Color(0xFF737373)),
                                SizedBox(width: 1),
                                Text(
                                  'Edit',
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
                if (swipeCardsPreference != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...swipeCardsPreference.answers.map((e) => Container(
                                height: 180,
                                width: 140,
                                margin: const EdgeInsets.only(right: 6),
                                child: ImageSwipeCardWidget(
                                    miniView: true,
                                    parsedAnswer: Map<String, String>.from(
                                        jsonDecode(e))),
                              ))
                        ],
                      ),
                    ),
                  ),
                Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(11),
                  child: Container(
                    height: (prompts?.length ?? 0) == 0 ? 20.h : null,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFD4D4D4)),
                        borderRadius: BorderRadius.circular(10)),
                    child: BlocBuilder(
                        bloc: sl<CardMarketBloc>(),
                        builder: (context, _) {
                          return ListView.builder(
                            itemCount: prompts?.length ?? 0,
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
                                  InkWell(
                                    onTap: () {
                                      if (sl<CardWalletPageBloc>().isUser) {
                                        Navigator.pushNamed(
                                            context,
                                            AppRoutes.cardMarketPlace
                                                .cardEditQuestions,
                                            arguments:
                                                EditCardQuestionsPageArgs(
                                                    sl<CardWalletPageBloc>()
                                                        .cardData!,
                                                    prompts[index]));
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
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
                                              Container(
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
                                            ],
                                          ),
                                        ),
                                        if (sl<CardWalletPageBloc>().isUser)
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Colors.grey,
                                          )
                                      ],
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
                ),
              ],
            ),
          );
        });
  }
}
