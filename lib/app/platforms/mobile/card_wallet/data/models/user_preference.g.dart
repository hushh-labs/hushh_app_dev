// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreference _$UserPreferenceFromJson(Map<String, dynamic> json) =>
    UserPreference(
      question: json['question'] as String,
      questionType:
          $enumDecodeNullable(_$CardQuestionTypeEnumMap, json['questionType']),
      answers:
          (json['answers'] as List<dynamic>?)?.map((e) => e as String).toList(),
      audioUrl: json['audio_url'] as String?,
      questionId: (json['question_id'] as num?)?.toInt(),
      content: json['content'] as String?,
      mandatory: json['mandatory'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserPreferenceToJson(UserPreference instance) =>
    <String, dynamic>{
      'question': instance.question,
      'questionType': _$CardQuestionTypeEnumMap[instance.questionType],
      'answers': instance.answers,
      'audio_url': instance.audioUrl,
      'metadata': instance.metadata,
      'question_id': instance.questionId,
      'mandatory': instance.mandatory,
      'content': instance.content,
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
