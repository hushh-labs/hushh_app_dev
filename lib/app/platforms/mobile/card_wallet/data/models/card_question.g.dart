// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardQuestion _$CardQuestionFromJson(Map<String, dynamic> json) => CardQuestion(
      questionId: (json['question_id'] as num).toInt(),
      questionText: json['question_text'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      cardQuestionType:
          $enumDecode(_$CardQuestionTypeEnumMap, json['card_question_type']),
    );

Map<String, dynamic> _$CardQuestionToJson(CardQuestion instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'question_text': instance.questionText,
      'answers': instance.answers,
      'card_question_type':
          _$CardQuestionTypeEnumMap[instance.cardQuestionType]!,
    };

const _$CardQuestionTypeEnumMap = {
  CardQuestionType.multiSelectQuestion: 'multiSelectQuestion',
  CardQuestionType.singleSelectQuestion: 'singleSelectQuestion',
  CardQuestionType.textNoteQuestion: 'textNoteQuestion',
  CardQuestionType.audioNoteQuestion: 'audioNoteQuestion',
  CardQuestionType.imageGridQuestion: 'imageGridQuestion',
  CardQuestionType.imageSwipeQuestion: 'imageSwipeQuestion',
  CardQuestionType.singleImageUploadQuestion: 'singleImageUploadQuestion',
  CardQuestionType.multiImageUploadQuestion: 'multiImageUploadQuestion',
};

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      answerId: (json['answer_id'] as num?)?.toInt(),
      answerText: json['answer_text'] as String?,
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'answer_id': instance.answerId,
      'answer_text': instance.answerText,
    };
