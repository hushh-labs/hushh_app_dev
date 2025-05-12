// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_transcription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioTranscription _$AudioTranscriptionFromJson(Map<String, dynamic> json) =>
    AudioTranscription(
      text: json['text'] as String,
      words: AudioTranscription._wordsFromJson(
          json['words'] as Map<String, dynamic>),
      language: json['language'] as String,
      modelName: json['model_name'] as String,
      inferenceTime: (json['inference_time'] as num).toDouble(),
    );

Map<String, dynamic> _$AudioTranscriptionToJson(AudioTranscription instance) =>
    <String, dynamic>{
      'text': instance.text,
      'words': instance.words,
      'language': instance.language,
      'model_name': instance.modelName,
      'inference_time': instance.inferenceTime,
    };

Word _$WordFromJson(Map<String, dynamic> json) => Word(
      text: json['text'] as String,
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'text': instance.text,
      'start': instance.start,
      'end': instance.end,
      'confidence': instance.confidence,
    };
