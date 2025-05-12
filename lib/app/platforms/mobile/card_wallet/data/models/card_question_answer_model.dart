import 'package:hive/hive.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';

part 'card_question_answer_model.g.dart';

@HiveType(typeId: 7)
class CardQuestionAnswerModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  String? answer;

  @HiveField(3)
  final bool editable;

  @HiveField(4)
  final CustomCardAnswerType type;

  @HiveField(5)
  final List<String>? choices;

  @HiveField(6)
  final DateTime? dateTime;

  CardQuestionAnswerModel({
    required this.id,
    required this.question,
    this.answer,
    this.dateTime,
    this.choices,
    this.editable = true,
    required this.type,
  });

  factory CardQuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    return CardQuestionAnswerModel(
      id: json['id'],
      question: json['question'] as String,
      dateTime: json['date_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['date_time'])
          : null,
      choices: json['choices'] != null ? List<String>.from(json['choices']) : null,
      answer: json['answer'] as String?,
      editable: json['editable'],
      type: CustomCardAnswerType.values
          .firstWhere((element) => element.name == json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'date_time': dateTime?.millisecondsSinceEpoch,
      'choices': choices,
      'editable': editable,
      'type': type.name,
    };
  }
}

List<Map<String, dynamic>> defaultHushhIdCardQuestions(Map? data) => [
      {
        'id': 'name',
        "question": "Full Name",
        "answer": AppLocalStorage.user?.name ?? "N/A",
        "date_time": null,
        "choices": null,
        "editable": false,
        "type": "text"
      },
      {
        'id': 'phone',
        "question": "Phone Number",
        "answer": AppLocalStorage.user!.phoneNumberWithCountryCode,
        "date_time": null,
        "choices": null,
        "editable": false,
        "type": "numberText"
      },
      {
        'id': 'work_email',
        "question": "Email Address",
        "answer": data?['email'],
        "date_time": null,
        "choices": null,
        "editable": data?['email'] == null,
        "type": "text"
      },
      {
        'id': 'social_media',
        "question": "Social Media",
        "answer": null,
        "date_time": null,
        "choices": null,
        "editable": true,
        "type": "social"
      },
      {
        'id': 'website',
        "question": "Website",
        "answer": null,
        "date_time": null,
        "choices": null,
        "editable": true,
        "type": "text"
      }
    ];

List<Map<String, dynamic>> defaultDemographicCardQuestions(Map? data) => [
      {
        'id': 'name',
        "question": "Full Name",
        "answer": AppLocalStorage.user?.name ?? "N/A",
        "date_time": null,
        "choices": null,
        "editable": false,
        "type": "text"
      },
      {
        'id': 'dob',
        "question": "Date of Birth",
        "answer": data?['dob'],
        "date_time": null,
        "choices": null,
        "editable": true,
        "type": "calendar"
      },
      {
        'id': 'gender',
        "question": "Gender",
        "answer": data?['gender'],
        "date_time": null,
        "choices": [
          'Male',
          'Female',
          'Non-Binary',
          'Transgender',
          'Genderqueer',
          'Agender',
          'Other',
        ],
        "editable": true,
        "type": "choice"
      },
      {
        'id': 'phone',
        "question": "Phone Number",
        "answer": AppLocalStorage.user!.phoneNumberWithCountryCode,
        "date_time": null,
        "choices": null,
        "editable": false,
        "type": "numberText"
      },
      {
        'id': 'email',
        "question": "Email Address",
        "answer": data?['email'],
        "date_time": null,
        "choices": null,
        "editable": data?['email'] == null,
        "type": "text"
      },
      {
        'id': 'education',
        "question": "Education",
        "answer": null,
        "date_time": null,
        "choices": [
          'High School Diploma',
          "Associate's Degree",
          "Bachelor's Degree",
          "Master's Degree",
          "Other",
        ],
        "editable": true,
        "type": "choice"
      },
      {
        'id': 'income',
        "question": "Income",
        "answer": null,
        "date_time": null,
        "choices": [
          r"Less than $20,000 per year",
          r"$20,000 - $40,000 per year",
          r"$40,001 - $60,000 per year",
          r"$60,001 - $80,000 per year",
          r"$80,001 - $100,000 per year",
          r"$100,001 - $150,000 per year",
          r"$150,001 - $200,000 per year",
          r"More than $200,000 per year",
          r"Prefer not to disclose",
        ],
        "editable": true,
        "type": "choice"
      },
      {
        'id': 'blood_type',
        "question": "Blood Type",
        "answer": null,
        "date_time": null,
        "choices": [
          "A positive (A+)",
          "A negative (A-)",
          "B positive (B+)",
          "B negative (B-)",
          "AB positive (AB+)",
          "AB negative (AB-)",
          "O positive (O+)",
          "O negative (O-)",
          "Unknown/Unsure",
        ],
        "editable": true,
        "type": "choice"
      },
    ];
