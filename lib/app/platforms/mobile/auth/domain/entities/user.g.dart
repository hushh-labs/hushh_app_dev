// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      avatar: fields[1] as String?,
      creationTime: fields[2] as String?,
      dob: fields[3] as String?,
      email: fields[4] as String?,
      fcmToken: fields[5] as String?,
      gender: fields[6] as String?,
      privateMode: fields[7] as bool?,
      role: fields[8] as Entity?,
      hushhId: fields[9] as String?,
      userCoins: fields[10] as int?,
      conversations: (fields[11] as List?)?.cast<String>(),
      gptTokenUsage: fields[12] as int?,
      lastUsedTokenDateTime: fields[13] as DateTime?,
      demographicCardQuestions:
          (fields[14] as List?)?.cast<CardQuestionAnswerModel>(),
      hushhIdCardQuestions:
          (fields[15] as List?)?.cast<CardQuestionAnswerModel>(),
      isHushhButtonUser: fields[17] as bool,
      isHushhExtensionUser: fields[18] as bool,
      isHushhVibeUser: fields[19] as bool,
      isHushhAppUser: fields[16] as bool,
      phoneNumber: fields[21] as String?,
      countryCode: fields[22] as String?,
      firstName: fields[23] as String?,
      lastName: fields[24] as String?,
      profileVideo: fields[25] as String?,
      selectedReasonForUsingHushh: fields[26] as String?,
      dobUpdatedAt: fields[27] as DateTime?,
      onboardStatus: fields[20] as OnboardStatus,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(27)
      ..writeByte(1)
      ..write(obj.avatar)
      ..writeByte(2)
      ..write(obj.creationTime)
      ..writeByte(3)
      ..write(obj.dob)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.fcmToken)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.privateMode)
      ..writeByte(8)
      ..write(obj.role)
      ..writeByte(9)
      ..write(obj.hushhId)
      ..writeByte(10)
      ..write(obj.userCoins)
      ..writeByte(11)
      ..write(obj.conversations)
      ..writeByte(12)
      ..write(obj.gptTokenUsage)
      ..writeByte(13)
      ..write(obj.lastUsedTokenDateTime)
      ..writeByte(14)
      ..write(obj.demographicCardQuestions)
      ..writeByte(15)
      ..write(obj.hushhIdCardQuestions)
      ..writeByte(16)
      ..write(obj.isHushhAppUser)
      ..writeByte(17)
      ..write(obj.isHushhButtonUser)
      ..writeByte(18)
      ..write(obj.isHushhExtensionUser)
      ..writeByte(19)
      ..write(obj.isHushhVibeUser)
      ..writeByte(20)
      ..write(obj.onboardStatus)
      ..writeByte(21)
      ..write(obj.phoneNumber)
      ..writeByte(22)
      ..write(obj.countryCode)
      ..writeByte(23)
      ..write(obj.firstName)
      ..writeByte(24)
      ..write(obj.lastName)
      ..writeByte(25)
      ..write(obj.profileVideo)
      ..writeByte(26)
      ..write(obj.selectedReasonForUsingHushh)
      ..writeByte(27)
      ..write(obj.dobUpdatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      avatar: json['avatar'] as String?,
      creationTime: json['creationtime'] as String?,
      dob: json['dob'] as String?,
      email: json['email'] as String?,
      fcmToken: json['fcmToken'] as String?,
      gender: json['gender'] as String?,
      privateMode: json['private_mode'] as bool?,
      role: $enumDecodeNullable(_$EntityEnumMap, json['role']),
      hushhId: json['hushh_id'] as String?,
      userCoins: (json['user_coins'] as num?)?.toInt(),
      conversations: (json['conversations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      gptTokenUsage: (json['gpt_token_usage'] as num?)?.toInt() ??
          DEFAULT_GPT_TOKEN_PER_MONTH,
      lastUsedTokenDateTime: json['last_used_token_date_time'] == null
          ? null
          : DateTime.parse(json['last_used_token_date_time'] as String),
      demographicCardQuestions:
          (json['demographic_card_questions'] as List<dynamic>?)
              ?.map((e) =>
                  CardQuestionAnswerModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      hushhIdCardQuestions: (json['hushh_id_card_questions'] as List<dynamic>?)
          ?.map((e) =>
              CardQuestionAnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isHushhButtonUser: json['is_hushh_button_user'] as bool? ?? false,
      isHushhExtensionUser: json['is_browser_companion_user'] as bool? ?? false,
      isHushhVibeUser: json['is_hushh_vibe_user'] as bool? ?? false,
      isHushhAppUser: json['is_hushh_app_user'] as bool? ?? false,
      phoneNumber: json['phone_number'] as String?,
      countryCode: json['country_code'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      profileVideo: json['profileVideo'] as String?,
      selectedReasonForUsingHushh:
          json['selected_reason_for_using_hushh'] as String?,
      dobUpdatedAt: json['dob_updated_at'] == null
          ? null
          : DateTime.parse(json['dob_updated_at'] as String),
      onboardStatus:
          $enumDecode(_$OnboardStatusEnumMap, json['onboard_status']),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'avatar': instance.avatar,
      'creationtime': instance.creationTime,
      'dob': instance.dob,
      'email': instance.email,
      'fcmToken': instance.fcmToken,
      'gender': instance.gender,
      'private_mode': instance.privateMode,
      'role': _$EntityEnumMap[instance.role],
      'hushh_id': instance.hushhId,
      'user_coins': instance.userCoins,
      'conversations': instance.conversations,
      'gpt_token_usage': instance.gptTokenUsage,
      'last_used_token_date_time':
          instance.lastUsedTokenDateTime?.toIso8601String(),
      'demographic_card_questions': instance.demographicCardQuestions,
      'hushh_id_card_questions': instance.hushhIdCardQuestions,
      'is_hushh_app_user': instance.isHushhAppUser,
      'is_hushh_button_user': instance.isHushhButtonUser,
      'is_browser_companion_user': instance.isHushhExtensionUser,
      'is_hushh_vibe_user': instance.isHushhVibeUser,
      'onboard_status': _$OnboardStatusEnumMap[instance.onboardStatus]!,
      'phone_number': instance.phoneNumber,
      'country_code': instance.countryCode,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'profileVideo': instance.profileVideo,
      'selected_reason_for_using_hushh': instance.selectedReasonForUsingHushh,
      'dob_updated_at': instance.dobUpdatedAt?.toIso8601String(),
    };

const _$EntityEnumMap = {
  Entity.user: 'user',
  Entity.agent: 'agent',
  Entity.button_Admin: 'button_Admin',
};

const _$OnboardStatusEnumMap = {
  OnboardStatus.authenticated: 'authenticated',
  OnboardStatus.signed_up: 'signed_up',
};
