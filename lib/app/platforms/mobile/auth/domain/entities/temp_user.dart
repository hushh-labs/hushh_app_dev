import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temp_user_keys.dart';
part 'temp_user.g.dart';

@JsonSerializable()
@HiveType(typeId: 14)
class TempUserModel {
  @HiveField(1)
  @JsonKey(name: TempUserKeys.avatarKey)
  final String? avatar;

  @HiveField(2)
  @JsonKey(name: TempUserKeys.nameKey)
  final String? name;

  @HiveField(3)
  @JsonKey(name: TempUserKeys.countryCodeKey)
  final String? countryCode;

  @HiveField(4)
  @JsonKey(name: TempUserKeys.phoneNumberKey)
  final String? phoneNumber;

  @HiveField(5)
  @JsonKey(name: TempUserKeys.emailKey)
  final String? email;

  @HiveField(6)
  @JsonKey(name: TempUserKeys.isAppleSignInKey)
  final bool? isAppleSignIn;

  TempUserModel({
    this.avatar,
    this.name,
    this.countryCode,
    this.phoneNumber,
    this.email,
    this.isAppleSignIn,
  });

  factory TempUserModel.fromJson(Map<String, dynamic> json) =>
      _$TempUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$TempUserModelToJson(this);
}
