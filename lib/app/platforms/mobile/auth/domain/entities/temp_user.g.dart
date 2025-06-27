// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temp_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TempUserModelAdapter extends TypeAdapter<TempUserModel> {
  @override
  final int typeId = 14;

  @override
  TempUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TempUserModel(
      avatar: fields[1] as String?,
      name: fields[2] as String?,
      countryCode: fields[3] as String?,
      phoneNumber: fields[4] as String?,
      email: fields[5] as String?,
      isAppleSignIn: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TempUserModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.avatar)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.countryCode)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.isAppleSignIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TempUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TempUserModel _$TempUserModelFromJson(Map<String, dynamic> json) =>
    TempUserModel(
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
      countryCode: json['country'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      isAppleSignIn: json['is_apple_sign_in'] as bool?,
    );

Map<String, dynamic> _$TempUserModelToJson(TempUserModel instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'name': instance.name,
      'country': instance.countryCode,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'is_apple_sign_in': instance.isAppleSignIn,
    };
