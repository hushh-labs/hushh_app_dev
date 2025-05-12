import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_questions_common_widgets.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tuple/tuple.dart';

class EditCardQuestionsPageArgs {
  final CardModel card;
  final UserPreference userPreference;

  EditCardQuestionsPageArgs(this.card, this.userPreference);
}

class EditCardQuestionsPage extends StatefulWidget {
  const EditCardQuestionsPage({Key? key}) : super(key: key);

  @override
  State<EditCardQuestionsPage> createState() => _EditCardQuestionsPageState();
}

class _EditCardQuestionsPageState extends State<EditCardQuestionsPage> {
  final controller = sl<CardMarketBloc>();

  List<UserPreference> get userSelections => controller.userSelections;

  List<CardQuestion>? get cardQuestions => controller.cardQuestions;

  int get currentPage => controller.currentQuestionIndex;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final data = ModalRoute.of(context)!.settings.arguments!
          as EditCardQuestionsPageArgs;

      // // Extract data from arguments and initialize the state.
      // controller.userSelections = List<UserPreference>.generate(
      //   data.userPreference.answers.length,
      //   (index) => UserPreference(question: ''),
      // );

      controller.add(FetchCardQuestionsEvent(data.card.id!, context,
          question: data.userPreference.question));
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments!
        as EditCardQuestionsPageArgs;
    final cardData = data.card;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: '${cardData.brandName} Preferences',
        onBack: () => Navigator.pop(context),
      ),
      body: BlocBuilder<CardMarketBloc, CardMarketState>(
        bloc: controller,
        builder: (context, state) {
          if (state is FetchingCardQuestionsState || cardQuestions == null) {
            return const SizedBox();
          }

          return Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Column(
              //     children: [
              //       const Text(
              //         "Complete the preferences and earn 5 Hushh Coins 🎉",
              //         style: TextStyle(
              //           color: CupertinoColors.activeBlue,
              //           fontWeight: FontWeight.w400,
              //           fontSize: 12,
              //         ),
              //       ),
              //       const SizedBox(height: 6),
              //       GradientProgressIndicator(
              //         value:
              //         calculateProgress(currentPage, cardQuestions!.length),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView.builder(
                  controller: PageController(initialPage: currentPage),
                  itemCount: cardQuestions!.length,
                  onPageChanged: (int page) {},
                  itemBuilder: (context, index) {
                    final question = cardQuestions![index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            question.questionText,
                            style: const TextStyle(
                                color: Color(0xFF3D3D3D),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (question.subtitle != null)
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              question.subtitle!,
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        const SizedBox(height: 16),
                        CardQuestionAnswerView(
                          question: question,
                          nextLogic: (_) {},
                          cardData: cardData,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: HushhLinearGradientButton(
                  text: 'Update',
                  height: 48,
                  color: Colors.black,
                  onTap: handleUpdate,
                  radius: 12,
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  double calculateProgress(int currentPage, int totalQuestions) {
    if (totalQuestions == 0) return 0.0;
    return (currentPage + 1) / totalQuestions;
  }

  void handleUpdate() {
    final answers = userSelections[currentPage].answers;

    if (answers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one option to proceed.'),
        ),
      );
      return;
    }

    final data = ModalRoute.of(context)!.settings.arguments!
        as EditCardQuestionsPageArgs;
    final cardData = data.card;

    controller.add(
        UpdateAnswersEvent(currentPage, answers, context, cardData));
  }
}
