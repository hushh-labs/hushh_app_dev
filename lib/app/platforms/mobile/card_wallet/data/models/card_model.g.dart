// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardModelAdapter extends TypeAdapter<CardModel> {
  @override
  final int typeId = 13;

  @override
  CardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardModel(
      cid: fields[0] as int?,
      id: fields[1] as int?,
      brandName: fields[2] as String,
      name: fields[3] as String?,
      image: fields[4] as String,
      categoryId: fields[6] as int?,
      brandCategory: fields[5] as String?,
      category: fields[7] as String,
      type: fields[8] as int,
      audioUrl: fields[9] as String?,
      bodyImage: fields[10] as String?,
      logo: fields[11] as String,
      userId: fields[12] as String?,
      cardValue: fields[13] as String?,
      featured: fields[14] as int?,
      coins: fields[15] as String?,
      attachedBrandCardsCoins: fields[16] as String?,
      attachedPrefCardsCoins: fields[17] as String?,
      accessList: (fields[18] as List?)?.cast<String>(),
      installedTime: fields[19] as DateTime?,
      attachedCardIds: (fields[20] as List?)?.cast<String>(),
      attachedPrefCardIds: (fields[21] as List?)?.cast<String>(),
      domain: fields[23] as String?,
      brandId: fields[24] as int?,
      teamId: fields[25] as int?,
      gradient: (fields[27] as List?)?.cast<String>(),
      cardCurrency: fields[28] as String?,
      audioTranscription: fields[26] as AudioTranscription?,
    );
  }

  @override
  void write(BinaryWriter writer, CardModel obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.cid)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.brandName)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.brandCategory)
      ..writeByte(6)
      ..write(obj.categoryId)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.audioUrl)
      ..writeByte(10)
      ..write(obj.bodyImage)
      ..writeByte(11)
      ..write(obj.logo)
      ..writeByte(12)
      ..write(obj.userId)
      ..writeByte(13)
      ..write(obj.cardValue)
      ..writeByte(14)
      ..write(obj.featured)
      ..writeByte(15)
      ..write(obj.coins)
      ..writeByte(16)
      ..write(obj.attachedBrandCardsCoins)
      ..writeByte(17)
      ..write(obj.attachedPrefCardsCoins)
      ..writeByte(18)
      ..write(obj.accessList)
      ..writeByte(19)
      ..write(obj.installedTime)
      ..writeByte(20)
      ..write(obj.attachedCardIds)
      ..writeByte(21)
      ..write(obj.attachedPrefCardIds)
      ..writeByte(22)
      ..write(obj.brandPreferences)
      ..writeByte(23)
      ..write(obj.domain)
      ..writeByte(24)
      ..write(obj.brandId)
      ..writeByte(25)
      ..write(obj.teamId)
      ..writeByte(26)
      ..write(obj.audioTranscription)
      ..writeByte(27)
      ..write(obj.gradient)
      ..writeByte(28)
      ..write(obj.cardCurrency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardModel _$CardModelFromJson(Map<String, dynamic> json) => CardModel(
      cid: (json['cid'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      brandName: json['brand_name'] as String,
      name: json['name'] as String?,
      image: json['image'] as String,
      categoryId: (json['category_id'] as num?)?.toInt(),
      brandCategory: json['brand_category'] as String?,
      category: json['category'] as String,
      type: (json['type'] as num).toInt(),
      audioUrl: json['audio_url'] as String?,
      bodyImage: json['body_image'] as String?,
      logo: json['logo'] as String,
      userId: json['user_id'] as String?,
      cardValue: json['card_value'] as String?,
      featured: (json['featured'] as num?)?.toInt(),
      coins: json['coins'] as String?,
      attachedBrandCardsCoins: json['attached_brand_cards_coins'] as String?,
      attachedPrefCardsCoins: json['attached_pref_cards_coins'] as String?,
      accessList: (json['access_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      installedTime: json['installed_time'] == null
          ? null
          : DateTime.parse(json['installed_time'] as String),
      attachedCardIds: (json['attached_card_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      attachedPrefCardIds: (json['attached_pref_card_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      domain: json['domain'] as String?,
      brandId: (json['brandId'] as num?)?.toInt(),
      teamId: (json['team_id'] as num?)?.toInt(),
      gradient: (json['gradient'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      cardCurrency: json['card_currency'] as String?,
      audioTranscription: json['audio_transcription'] == null
          ? null
          : AudioTranscription.fromJson(
              json['audio_transcription'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CardModelToJson(CardModel instance) => <String, dynamic>{
      'cid': instance.cid,
      'id': instance.id,
      'brand_name': instance.brandName,
      'name': instance.name,
      'image': instance.image,
      'brand_category': instance.brandCategory,
      'category_id': instance.categoryId,
      'category': instance.category,
      'type': instance.type,
      'audio_url': instance.audioUrl,
      'body_image': instance.bodyImage,
      'logo': instance.logo,
      'user_id': instance.userId,
      'card_value': instance.cardValue,
      'featured': instance.featured,
      'coins': instance.coins,
      'attached_brand_cards_coins': instance.attachedBrandCardsCoins,
      'attached_pref_cards_coins': instance.attachedPrefCardsCoins,
      'access_list': instance.accessList,
      'installed_time': instance.installedTime?.toIso8601String(),
      'attached_card_ids': instance.attachedCardIds,
      'attached_pref_card_ids': instance.attachedPrefCardIds,
      'domain': instance.domain,
      'brandId': instance.brandId,
      'team_id': instance.teamId,
      'audio_transcription': instance.audioTranscription,
      'gradient': instance.gradient,
      'card_currency': instance.cardCurrency,
    };
