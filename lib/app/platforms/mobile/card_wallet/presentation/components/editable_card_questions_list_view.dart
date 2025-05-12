import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question_answer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/general_preference_bottom_sheet.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class EditableCardQuestionsListView extends StatefulWidget {
  final CustomCardQuestionsType customCardQuestionsType;

  const EditableCardQuestionsListView({
    super.key,
    required this.customCardQuestionsType,
  });

  @override
  State<EditableCardQuestionsListView> createState() =>
      _EditableCardQuestionsListViewState();
}

class _EditableCardQuestionsListViewState
    extends State<EditableCardQuestionsListView> {
  late bool isDemographicCard;
  final controller = sl<AgentCardWalletPageBloc>();

  @override
  void initState() {
    isDemographicCard = widget.customCardQuestionsType ==
        CustomCardQuestionsType.demographicCard;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: controller,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'General Preference',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.black),
                  ),
                  // Icon(Icons.keyboard_arrow_right)
                ],
              ),
              const SizedBox(height: 10),
              Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF2F2F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: FutureBuilder(
                      future: controller.getEditablePrompts(isDemographicCard),
                      builder: (context, state) {
                        bool loader = state.data == null;
                        List<CardQuestionAnswerModel>? prompts = state.data;
                        return loader
                            ? const Center(
                                child: CircularProgressIndicator.adaptive())
                            : ListView.builder(
                                itemCount: prompts?.length ?? 0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  final prompt = prompts!.elementAt(index);
                                  if (prompt.type == CustomCardAnswerType.social) {
                                    return const SizedBox();
                                  }
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: !prompt.editable
                                          ? null
                                          : () {
                                              final bottomSheet =
                                                  GeneralPreferenceBottomSheet(
                                                      context, prompt.question);
                                              switch (prompt.type) {
                                                case CustomCardAnswerType.text:
                                                  bottomSheet.text(
                                                      onChanged: (value) {
                                                        prompts
                                                            .where((element) =>
                                                                element.id ==
                                                                prompt.id)
                                                            .first
                                                            .answer = value;
                                                        controller
                                                            .onEditablePromptUpdated(
                                                          prompts,
                                                          value,
                                                          prompt.id,
                                                          context,
                                                        );
                                                      },
                                                      value: prompt.answer);
                                                  break;
                                                case CustomCardAnswerType.choice:
                                                  bottomSheet.choice(
                                                      onChanged: (choice) {
                                                        prompts
                                                            .where((element) =>
                                                                element.id ==
                                                                prompt.id)
                                                            .first
                                                            .answer = choice;
                                                        controller
                                                            .onEditablePromptUpdated(
                                                          prompts,
                                                          choice,
                                                          prompt.id,
                                                          context,
                                                        );
                                                      },
                                                      choices: prompt.choices!,
                                                      value: prompt.answer);
                                                  break;
                                                case CustomCardAnswerType.calendar:
                                                  bottomSheet.calendar(
                                                      onChanged: (dateTime) {
                                                        prompts
                                                                .where((element) =>
                                                                    element.id ==
                                                                    prompt.id)
                                                                .first
                                                                .answer =
                                                            DateFormat('yyyy-MM-dd')
                                                                .format(dateTime);
                                                        controller
                                                            .onEditablePromptUpdated(
                                                          prompts,
                                                          DateFormat('yyyy-mm-dd')
                                                              .format(dateTime),
                                                          prompt.id,
                                                          context,
                                                        );
                                                      },
                                                      value: prompt.answer != null
                                                          ? DateFormat('yyyy-mm-dd')
                                                              .parse(prompt.answer!)
                                                          : null);
                                                  break;
                                                case CustomCardAnswerType
                                                      .numberText:
                                                  bottomSheet.text(
                                                      onChanged: (value) {
                                                        prompts
                                                            .where((element) =>
                                                                element.id ==
                                                                prompt.id)
                                                            .first
                                                            .answer = value;
                                                        controller
                                                            .onEditablePromptUpdated(
                                                          prompts,
                                                          value,
                                                          prompt.id,
                                                          context,
                                                        );
                                                      },
                                                      type: TextInputType.number,
                                                      value: prompt.answer);
                                                  break;
                                                case CustomCardAnswerType.social:
                                                  ToastManager(Toast(
                                                          title: 'Coming Soon',
                                                          type: ToastificationType
                                                              .info))
                                                      .show(context);
                                              }
                                            },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                prompt.question
                                                    .toString()
                                                    .toUpperCase(),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Figtree',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              if (prompt.editable &&
                                                  prompt.type !=
                                                      CustomCardAnswerType.social)
                                                const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                )
                                            ],
                                          ),
                                          prompt.answer == null
                                              ? SizedBox(
                                                  height: 30,
                                                  child: prompt.type ==
                                                          CustomCardAnswerType
                                                              .social
                                                      ? IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                              Icons.add_box))
                                                      : const SizedBox(),
                                                )
                                              : SizedBox(
                                                  height: 30,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        prompt.answer!,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Color(0xff606060),
                                                          fontFamily: 'Figtree',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          if (index != prompts.length - 1)
                                            const Divider(
                                              color: Color(0xffE2E2E2),
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                      }),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
