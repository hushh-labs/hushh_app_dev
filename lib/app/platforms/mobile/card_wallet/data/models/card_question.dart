import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_question.g.dart';

@JsonSerializable()
class CardQuestion {
  @JsonKey(name: 'question_id')
  final int questionId;
  @JsonKey(name: 'question_text')
  final String questionText;
  @JsonKey(name: 'answers')
  final List<Answer> answers;
  @JsonKey(name: 'card_question_type')
  final CardQuestionType cardQuestionType;

  CardQuestion({
    required this.questionId,
    required this.questionText,
    required this.answers,
    required this.cardQuestionType,
  });

  String? get subtitle {
    switch(cardQuestionType) {
      case CardQuestionType.imageSwipeQuestion:
        return "(Swipe left for No and right for Yes)";
      default:
        return null;
    }
  }

  // Serialization methods
  factory CardQuestion.fromJson(Map<String, dynamic> json) =>
      _$CardQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$CardQuestionToJson(this);
}

@JsonSerializable()
class Answer {
  @JsonKey(name: 'answer_id')
  final int? answerId;
  @JsonKey(name: 'answer_text')
  final String? answerText;

  Answer({
    this.answerId,
    this.answerText,
  });

  // Serialization methods
  factory Answer.fromJson(Map<String, dynamic> json) =>
      _$AnswerFromJson(json);
  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}