import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_preference.g.dart';

@JsonSerializable()
class UserPreference {
  final String question;
  final CardQuestionType? questionType;
  List<String> answers;
  @JsonKey(name: 'audio_url')
  final String? audioUrl;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'question_id')
  final int? questionId;
  final bool mandatory;
  final String? content;

  UserPreference(
      {required this.question,
      this.questionType,
      List<String>? answers,
      this.audioUrl,
      this.questionId,
      this.content,
      this.mandatory = false,
      this.metadata})
      : answers = answers ?? [];

  factory UserPreference.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferenceToJson(this);
}
