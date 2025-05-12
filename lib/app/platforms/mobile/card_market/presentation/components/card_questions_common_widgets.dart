import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/gradientLinearProgressIndicator.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/components/swipebale.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: onBack,
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: const Center(
            child: Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
          ),
        ),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Figtree',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class GradientProgressIndicator extends StatelessWidget {
  final double value;

  const GradientProgressIndicator({Key? key, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientLinearProgressIndicator(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      value: value,
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xffE54D60),
          Color(0xffA342FF),
        ],
      ),
    );
  }
}

class CardQuestionAnswerView extends StatelessWidget {
  final CardQuestion question;
  final CardModel cardData;
  final Function(CardModel) nextLogic;

  const CardQuestionAnswerView(
      {super.key,
      required this.question,
      required this.cardData,
      required this.nextLogic});

  List<UserPreference> get userSelections =>
      sl<CardMarketBloc>().userSelections;

  int get currentQuestionIndex => sl<CardMarketBloc>().currentQuestionIndex;

  @override
  Widget build(BuildContext context) {
    switch (question.cardQuestionType) {
      case CardQuestionType.textNoteQuestion:
        return TextNoteQuestionWidget(
          hint: "Type your answer...",
          onChanged: (value) {
            userSelections[currentQuestionIndex].answers = [value];
          },
        );
      case CardQuestionType.multiSelectQuestion:
        return MultiSelectQuestionWidget(
          answers: question.answers.map((a) => a.answerText!).toList(),
          selectedAnswers: userSelections[currentQuestionIndex].answers,
          onSelect: (answer) {
            sl<CardMarketBloc>().add(ToggleCardQuestionAnswerSelectionEvent(
                answer, currentQuestionIndex));
          },
        );
      case CardQuestionType.imageGridQuestion:
        return ImageGridQuestionWidget(
          answers: question.answers.map((a) => a.answerText!).toList(),
          selectedAnswers: userSelections[currentQuestionIndex].answers,
          onSelect: (answer) {
            sl<CardMarketBloc>().add(ToggleCardQuestionAnswerSelectionEvent(
                answer, currentQuestionIndex));
          },
        );
      case CardQuestionType.imageSwipeQuestion:
        return ImageSwipeQuestionWidget(
          answers: question.answers.map((a) => Map<String, String>.from(jsonDecode(a.answerText!))).toList(),
          onComplete: () {
            nextLogic(cardData);
          },
          onSwipe: (answer) {
            sl<CardMarketBloc>().add(ToggleCardQuestionAnswerSelectionEvent(
                answer, currentQuestionIndex));
          },
        );
      case CardQuestionType.singleImageUploadQuestion:
        return BlocListener(
          bloc: sl<SharedAssetsReceiptsBloc>(),
          listener: (context, state) {
            if (state is ImagesVideosSharedState &&
                question.cardQuestionType ==
                    CardQuestionType.singleImageUploadQuestion) {
              if (state.url != null) {
                sl<CardMarketBloc>().add(ToggleCardQuestionAnswerSelectionEvent(
                    state.url!, currentQuestionIndex));
              }
            }
          },
          child: SingleImageUploadWidget(
            imageUrl: userSelections[currentQuestionIndex].answers.isNotEmpty
                ? userSelections[currentQuestionIndex].answers.last
                : null,
            cardData: cardData,
          ),
        );
      case CardQuestionType.multiImageUploadQuestion:
        return BlocConsumer(
            bloc: sl<SharedAssetsReceiptsBloc>(),
            listener: (context, state) {
              if (state is ImagesVideosSharedState &&
                  question.cardQuestionType ==
                      CardQuestionType.multiImageUploadQuestion) {
                if (state.url != null) {
                  sl<CardMarketBloc>().add(
                      ToggleCardQuestionAnswerSelectionEvent(
                          state.url!, currentQuestionIndex,
                          onlyAdd: true));
                }
              }
            },
            builder: (context, state) {
              return MultipleImageUploadWidget(
                answers: List<String?>.from(
                    userSelections[currentQuestionIndex].answers),
                cardData: cardData,
              );
            });
      default:
        return const SizedBox.shrink();
    }
  }
}

class ImageGridQuestionWidget extends StatelessWidget {
  final List<String> answers;
  final List<String> selectedAnswers;
  final ValueChanged<String> onSelect;

  const ImageGridQuestionWidget({
    Key? key,
    required this.answers,
    required this.selectedAnswers,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: answers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        final answer = answers[index];
        final isSelected = selectedAnswers.contains(answer);

        return InkWell(
          onTap: () => onSelect(answer),
          child: Container(
            decoration: isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
            child: Center(
              child: Image.network(answer), // Answer text treated as URL
            ),
          ),
        );
      },
    );
  }
}

class MultiSelectQuestionWidget extends StatelessWidget {
  final List<String> answers;
  final List<String> selectedAnswers;
  final ValueChanged<String> onSelect;

  const MultiSelectQuestionWidget({
    Key? key,
    required this.answers,
    required this.selectedAnswers,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: answers.length,
      itemBuilder: (context, index) {
        final answer = answers[index];
        final isSelected = selectedAnswers.contains(answer);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: InkWell(
            onTap: () => onSelect(answer),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE54D60), Color(0xFFA342FF)],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black),
                    ),
              child: Center(
                child: Text(
                  answer,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MultipleImageUploadWidget extends StatelessWidget {
  final List<String?> answers;
  final CardModel cardData;

  const MultipleImageUploadWidget({
    Key? key,
    required this.answers,
    required this.cardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/fashion_card_multi_image_banner.png',
            width: 90.w,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: SizedBox(
            width: 90.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: answers.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          sl<SharedAssetsReceiptsBloc>().add(
                              ShareImagesVideosEvent(context, cardData,
                                  pop: false));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  final imageUrl = answers[index - 1];
                  if (imageUrl != null) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 160,
                          width: 80,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          ),
        )
      ],
    );
  }
}

class TextNoteQuestionWidget extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const TextNoteQuestionWidget({
    Key? key,
    required this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14.0, color: Color(0xff181941)),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: CupertinoColors.extraLightBackgroundGray,
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 14.0,
          color: Color(0xFF7f7f97),
          fontWeight: FontWeight.w300,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: CupertinoColors.extraLightBackgroundGray),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: CupertinoColors.extraLightBackgroundGray),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: CupertinoColors.extraLightBackgroundGray),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class ImageSwipeQuestionWidget extends StatefulWidget {
  final List<Map<String, String>>
      answers; // List of JSON strings like {"image": "", "text": ""}
  final Function(Map<String, String> selectedAnswer) onSwipe; // Callback for each swipe
  final VoidCallback onComplete; // Callback for when all items are swiped

  const ImageSwipeQuestionWidget({
    Key? key,
    required this.answers,
    required this.onSwipe,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<ImageSwipeQuestionWidget> createState() =>
      _ImageSwipeQuestionWidgetState();
}

class _ImageSwipeQuestionWidgetState extends State<ImageSwipeQuestionWidget> {
  late List<Map<String, String>> remainingAnswers;

  @override
  void initState() {
    super.initState();
    remainingAnswers = List.from(widget.answers); // Clone the list
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: remainingAnswers.asMap().entries.map(
        (entry) {
          final int index = entry.key;
          final Map<String, String> jsonAnswer = entry.value;
          final Map<String, String> parsedAnswer = jsonAnswer;

          return Positioned(
            top: index * 10.0, // Staggered stack effect
            child: SizedBox(
              height: 50.h,
              width: 80.w,
              child: Swipable(
                verticalSwipe: false,
                onSwipeRight: (_) => handleSwipe(jsonAnswer),
                onSwipeLeft: (_) => handleSwipe(jsonAnswer),
                child: ImageSwipeCardWidget(parsedAnswer: parsedAnswer),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  void handleSwipe(Map<String, String> jsonAnswer) {
    // Trigger the onSwipe callback
    widget.onSwipe(jsonAnswer);

    setState(() {
      // Remove the swiped item from the list
      remainingAnswers.remove(jsonAnswer);

      // Check if the stack is empty
      if (remainingAnswers.isEmpty) {
        widget.onComplete();
      }
    });
  }
}

class ImageSwipeCardWidget extends StatelessWidget {
  final Map<String, String> parsedAnswer;
  final bool miniView;

  const ImageSwipeCardWidget(
      {super.key, required this.parsedAnswer, this.miniView = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: miniView ? 2 : 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(miniView ? 8 : 16).copyWith(bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  parsedAnswer['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  parsedAnswer['text']!,
                  style: TextStyle(
                    fontSize: miniView ? 12 : 24,
                    fontWeight: miniView ? null : FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SingleImageUploadWidget extends StatelessWidget {
  final String? imageUrl;
  final CardModel cardData;

  const SingleImageUploadWidget({
    Key? key,
    required this.imageUrl,
    required this.cardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              sl<SharedAssetsReceiptsBloc>()
                  .add(ShareImagesVideosEvent(context, cardData, pop: false));
            },
            child: Container(
              height: imageUrl == null ? null : 40.h,
              width: imageUrl == null ? null : 60.w,
              padding: imageUrl != null
                  ? null
                  : EdgeInsets.symmetric(horizontal: 16, vertical: 15.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: imageUrl == null || imageUrl!.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IonIcons.camera,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Open camera and add image",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 32)
        ],
      ),
    );
  }
}
