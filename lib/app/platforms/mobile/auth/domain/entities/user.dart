import 'package:hive/hive.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question_answer_model.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

part 'user_keys.dart';

const DEFAULT_GPT_TOKEN_PER_MONTH = 500000;

@JsonSerializable()
@HiveType(typeId: 1)
class UserModel {
  @HiveField(1)
  @JsonKey(name: UserKeys.avatarKey)
  final String? avatar;

  @HiveField(2)
  @JsonKey(name: UserKeys.creationTimeKey)
  final String? creationTime;

  @HiveField(3)
  @JsonKey(name: UserKeys.dobKey)
  final String? dob;

  @HiveField(4)
  @JsonKey(name: UserKeys.emailKey)
  final String? email;

  @HiveField(5)
  @JsonKey(name: UserKeys.fcmTokenKey)
  final String? fcmToken;

  @HiveField(6)
  @JsonKey(name: UserKeys.genderKey)
  final String? gender;

  @HiveField(7)
  @JsonKey(name: UserKeys.privateModeKey)
  final bool? privateMode;

  @HiveField(8)
  @JsonKey(name: UserKeys.roleKey)
  final Entity? role;

  @HiveField(9)
  @JsonKey(name: UserKeys.hushhIdKey)
  final String? hushhId;

  @HiveField(10)
  @JsonKey(name: UserKeys.userCoinsKey)
  final int? userCoins;

  @HiveField(11)
  @JsonKey(name: UserKeys.conversationsKey)
  List<String>? conversations;

  @HiveField(12)
  @JsonKey(name: 'gpt_token_usage')
  int? gptTokenUsage;

  @HiveField(13)
  @JsonKey(name: 'last_used_token_date_time')
  DateTime? lastUsedTokenDateTime;

  @HiveField(14)
  @JsonKey(name: 'demographic_card_questions')
  List<CardQuestionAnswerModel>? demographicCardQuestions;

  @HiveField(15)
  @JsonKey(name: 'hushh_id_card_questions')
  List<CardQuestionAnswerModel>? hushhIdCardQuestions;

  @HiveField(16)
  @JsonKey(name: 'is_hushh_app_user')
  bool isHushhAppUser;

  @HiveField(17)
  @JsonKey(name: 'is_hushh_button_user')
  bool isHushhButtonUser;

  @HiveField(18)
  @JsonKey(name: 'is_browser_companion_user')
  bool isHushhExtensionUser;

  @HiveField(19)
  @JsonKey(name: 'is_hushh_vibe_user')
  bool isHushhVibeUser;

  @HiveField(20)
  @JsonKey(name: 'onboard_status')
  OnboardStatus onboardStatus;

  @HiveField(21)
  @JsonKey(name: 'phone_number')
  String? phoneNumber;

  @HiveField(22)
  @JsonKey(name: 'country_code')
  String? countryCode;

  @HiveField(23)
  @JsonKey(name: 'first_name')
  String? firstName;

  @HiveField(24)
  @JsonKey(name: 'last_name')
  String? lastName;

  @HiveField(25)
  @JsonKey(name: 'profileVideo')
  String? profileVideo;

  @HiveField(26)
  @JsonKey(name: 'selected_reason_for_using_hushh')
  String? selectedReasonForUsingHushh;

  UserModel(
      {this.avatar,
      this.creationTime,
      this.dob,
      this.email,
      this.fcmToken,
      this.gender,
      this.privateMode,
      this.role,
      this.hushhId,
      this.userCoins,
      this.conversations,
      this.gptTokenUsage = DEFAULT_GPT_TOKEN_PER_MONTH,
      this.lastUsedTokenDateTime,
      this.demographicCardQuestions,
      this.hushhIdCardQuestions,
      this.isHushhButtonUser = false,
      this.isHushhExtensionUser = false,
      this.isHushhVibeUser = false,
      this.isHushhAppUser = false,
      this.phoneNumber,
      this.countryCode,
      this.firstName,
      this.lastName,
      this.profileVideo,
      this.selectedReasonForUsingHushh,
      required this.onboardStatus});

  String get name => "${firstName ?? ""} ${lastName ?? ""}".capitalize();

  String get phoneNumberWithCountryCode =>
      "+${countryCode?.replaceAll('+', '') ?? ""}${phoneNumber ?? ""}";

  String get phoneNumberWithoutCountryCode =>
      (phoneNumber ?? "").replaceFirst(countryCode ?? "", "");

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith(
      {String? avatar,
      String? creationTime,
      String? dob,
      String? email,
      String? fcmToken,
      String? gender,
      bool? privateMode,
      Entity? role,
      String? hushhId,
      int? userCoins,
      List<String>? conversations,
      int? gptTokenUsage,
      DateTime? lastUsedTokenDateTime,
      bool? isHushhAppUser,
      bool? isHushhButtonUser,
      bool? isHushhExtensionUser,
      bool? isHushhVibeUser,
      OnboardStatus? onboardStatus,
      String? phoneNumber,
      String? countryCode,
      String? firstName,
      String? lastName,
      String? profileVideo,
      List<CardQuestionAnswerModel>? demographicCardQuestions,
      List<CardQuestionAnswerModel>? hushhIdCardQuestions}) {
    return UserModel(
      onboardStatus: onboardStatus ?? this.onboardStatus,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileVideo: profileVideo ?? this.profileVideo,
      avatar: avatar ?? this.avatar,
      creationTime: creationTime ?? this.creationTime,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      fcmToken: fcmToken ?? this.fcmToken,
      gender: gender ?? this.gender,
      privateMode: privateMode ?? this.privateMode,
      role: role ?? this.role,
      hushhId: hushhId ?? this.hushhId,
      userCoins: userCoins ?? this.userCoins,
      conversations: conversations ?? List.from(this.conversations ?? []),
      gptTokenUsage: gptTokenUsage ?? this.gptTokenUsage,
      demographicCardQuestions:
          demographicCardQuestions ?? this.demographicCardQuestions,
      hushhIdCardQuestions: hushhIdCardQuestions ?? this.hushhIdCardQuestions,
      isHushhAppUser: isHushhAppUser ?? this.isHushhAppUser,
      isHushhButtonUser: isHushhButtonUser ?? this.isHushhButtonUser,
      isHushhExtensionUser: isHushhExtensionUser ?? this.isHushhExtensionUser,
      isHushhVibeUser: isHushhVibeUser ?? this.isHushhVibeUser,
      lastUsedTokenDateTime:
          lastUsedTokenDateTime ?? this.lastUsedTokenDateTime,
    );
  }

  UserModel copyWithFromJson(Map<String, dynamic>? json) {
    if (json == null) return this;

    return copyWith(
      avatar: json[UserKeys.avatarKey] ?? avatar,
      creationTime: json[UserKeys.creationTimeKey] ?? creationTime,
      dob: json[UserKeys.dobKey] ?? dob,
      email: json[UserKeys.emailKey] ?? email,
      fcmToken: json[UserKeys.fcmTokenKey] ?? fcmToken,
      gender: json[UserKeys.genderKey] ?? gender,
      privateMode: json[UserKeys.privateModeKey] ?? privateMode,
      role: json[UserKeys.roleKey] ?? role,
      hushhId: json[UserKeys.hushhIdKey] ?? hushhId,
      userCoins: json[UserKeys.userCoinsKey] ?? userCoins,
      conversations: json[UserKeys.conversationsKey] != null
          ? List<String>.from(json[UserKeys.conversationsKey])
          : conversations,
      isHushhAppUser: json['is_hushh_app_user'] ?? isHushhAppUser,
      isHushhButtonUser: json['is_hushh_button_user'] ?? isHushhButtonUser,
      isHushhExtensionUser:
          json['is_browser_companion_user'] ?? isHushhExtensionUser,
      isHushhVibeUser: json['is_hushh_vibe_user'] ?? isHushhVibeUser,
      gptTokenUsage: json['gpt_token_usage'] ?? gptTokenUsage,
      lastUsedTokenDateTime: json['last_used_token_date_time'] != null
          ? DateTime.parse(json['last_used_token_date_time'])
          : lastUsedTokenDateTime,
      demographicCardQuestions: json['demographic_card_questions'] != null
          ? List<CardQuestionAnswerModel>.from(
              json['demographic_card_questions']
                  .map((x) => CardQuestionAnswerModel.fromJson(x)))
          : demographicCardQuestions,
      hushhIdCardQuestions: json['hushh_id_card_questions'] != null
          ? List<CardQuestionAnswerModel>.from(json['hushh_id_card_questions']
              .map((x) => CardQuestionAnswerModel.fromJson(x)))
          : hushhIdCardQuestions,
    );
  }

  DateTime getLastTokenMonth() {
    DateTime dateTime = DateTime.parse(creationTime!);
    DateTime currentDateTime = DateTime.now();
    // Extract day and month from the given dateTime
    int day = dateTime.day;
    int month = dateTime.month;

    // Extract month and year from the currentDateTime
    int currentMonth = currentDateTime.month;
    int currentYear = currentDateTime.year;

    // Calculate the difference in months between the given dateTime and currentDateTime
    int monthDiff = currentMonth - month;

    // Adjust the year if the given dateTime's month is ahead of the current month
    if (monthDiff < 0) {
      currentYear--;
    }

    // Calculate the new month based on the nearest month to currentDateTime
    int newMonth = currentMonth - monthDiff % 12;

    // If newMonth becomes 0, set it to December of the previous year
    if (newMonth <= 0) {
      newMonth += 12;
      currentYear--;
    }

    // Create and return the monthlyDateTime
    return DateTime(currentYear, newMonth, day);
  }
}
