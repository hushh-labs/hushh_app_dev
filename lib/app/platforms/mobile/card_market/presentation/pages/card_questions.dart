import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_questions_common_widgets.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/audio_notes.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/components/hushh_secondary_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:icons_plus/icons_plus.dart';

class CardQuestionsPage extends StatefulWidget {
  const CardQuestionsPage({Key? key}) : super(key: key);

  @override
  State<CardQuestionsPage> createState() => _CardQuestionsPageState();
}

class _CardQuestionsPageState extends State<CardQuestionsPage> {
  final PageController pageController = PageController();
  final controller = sl<CardMarketBloc>();

  int get currentPage => controller.currentQuestionIndex;

  List<UserPreference> get userSelections => controller.userSelections;

  List<CardQuestion>? get cardQuestions => controller.cardQuestions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.currentQuestionIndex = 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardData = ModalRoute.of(context)!.settings.arguments! as CardModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: cardData.brandName,
        onBack: () {
          if (currentPage == 0) {
            Navigator.pop(context);
          } else {
            pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
      ),
      body: BlocBuilder<CardMarketBloc, CardMarketState>(
        bloc: controller,
        builder: (context, state) {
          if (state is FetchingCardQuestionsState || cardQuestions == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const Text(
                      "Complete the preferences and earn 5 Hushh Coins 🎉",
                      style: TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GradientProgressIndicator(
                      value:
                          calculateProgress(currentPage, cardQuestions!.length),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: cardQuestions!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) => setState(() {
                    controller.currentQuestionIndex = page;
                  }),
                  itemBuilder: (context, index) {
                    final question = cardQuestions![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 32),
                        Expanded(
                          child: CardQuestionAnswerView(
                              question: question,
                              nextLogic: nextLogic,
                              cardData: cardData),
                        ),
                        buildNextButton(cardData, question.cardQuestionType),
                        const SizedBox(height: 32)
                      ],
                    );
                  },
                ),
              )
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

  Widget buildNextButton(CardModel cardData, CardQuestionType questionType) {
    Widget nextRow() {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Next",
            style: TextStyle(
                color: Color(0xffFFFFFF), fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 4),
          Icon(
            EvaIcons.arrow_forward,
            size: 16,
            color: Colors.white,
          )
        ],
      );
    }

    Widget uploadImageRow() {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add,
            size: 16,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Upload Image",
            style: TextStyle(
                color: Color(0xffFFFFFF), fontWeight: FontWeight.w600),
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: HushhLinearGradientButton(
            text: questionType == CardQuestionType.singleImageUploadQuestion &&
                    userSelections[currentPage].answers.isEmpty
                ? 'Upload'
                : 'Next',
            height: 48,
            color: Colors.black,
            onTap: () async {
              if (questionType == CardQuestionType.singleImageUploadQuestion &&
                  userSelections[currentPage].answers.isEmpty) {
                sl<SharedAssetsReceiptsBloc>()
                    .add(ShareImagesVideosEvent(context, cardData, pop: false));
              } else {
                nextLogic(cardData);
              }
            },
            radius: 12,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: HushhSecondaryButton(
            text: 'Skip',
            height: 48,
            onTap: () {
              nextLogic(cardData, skip: true);
            },
            radius: 12,
          ),
        ),
      ],
    );
  }

  void nextLogic(CardModel cardData,
      {bool checkForOneAnswer = true, bool skip = false}) {
    if (currentPage == cardQuestions!.length - 1) {
      // Proceed to the next step
      Navigator.pushNamed(
        context,
        AppRoutes.cardMarketPlace.audioNotes,
        arguments: AudioNotesArgs(
          cardData: cardData,
          userSelections: userSelections,
        ),
      );
    } else if (userSelections[currentPage].answers.isNotEmpty || skip) {
      // Go to the next page
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Show a warning
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one option to proceed.'),
        ),
      );
    }
  }
}
