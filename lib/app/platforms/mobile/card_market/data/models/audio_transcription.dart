import 'package:json_annotation/json_annotation.dart';

part 'audio_transcription.g.dart';

@JsonSerializable()
class AudioTranscription {
  final String text;
  @JsonKey(fromJson: _wordsFromJson)
  final List<Word> words;
  final String language;
  @JsonKey(name: 'model_name')
  final String modelName;
  @JsonKey(name: 'inference_time')
  final double inferenceTime;

  AudioTranscription({
    required this.text,
    required this.words,
    required this.language,
    required this.modelName,
    required this.inferenceTime,
  });

  static List<Word> _wordsFromJson(Map<String, dynamic> json) {
    List<Word> allWords = [];
    if (json['segments'] != null) {
      for (var segment in (json['segments'] as List)) {
        if (segment['words'] != null) {
          for (var word in (segment['words'] as List)) {
            allWords.add(Word.fromJson(word as Map<String, dynamic>));
          }
        }
      }
    }
    return allWords;
  }

  factory AudioTranscription.fromJson(Map<String, dynamic> json) {
    // Extract all words from segments
    List<Word> allWords = [];
    if (json['segments'] != null) {
      for (var segment in json['segments']) {
        if (segment['words'] != null) {
          for (var word in segment['words']) {
            allWords.add(Word.fromJson(word));
          }
        }
      }
    } else {
      allWords =
          List<Word>.from(json['words'].map((e) => Word.fromJson(e)).toList());
    }

    return AudioTranscription(
      text: json['text'] ?? '',
      words: allWords,
      language: json['language'] ?? '',
      modelName: json['model_name'] ?? '',
      inferenceTime: (json['inference_time'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => _$AudioTranscriptionToJson(this);
}

@JsonSerializable()
class Word {
  final String text;
  final double start;
  final double end;
  final double confidence;

  Word({
    required this.text,
    required this.start,
    required this.end,
    required this.confidence,
  });

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  Map<String, dynamic> toJson() => _$WordToJson(this);
}
