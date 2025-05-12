import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/audio_transcription.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/shared/core/utils/color_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 13)
class CardModel extends Equatable {
  @JsonKey(name: 'cid')
  @HiveField(0)
  final int? cid;

  @JsonKey(name: 'id')
  @HiveField(1)
  final int? id;

  @JsonKey(name: 'brand_name')
  @HiveField(2)
  final String brandName;

  @JsonKey(name: 'name')
  @HiveField(3)
  final String? name;

  @JsonKey(name: 'image')
  @HiveField(4)
  final String image;

  @JsonKey(name: 'brand_category')
  @HiveField(5)
  final String? brandCategory;

  @JsonKey(name: 'category_id')
  @HiveField(6)
  final int? categoryId;

  @JsonKey(name: 'category')
  @HiveField(7)
  final String category;

  @JsonKey(name: 'type')
  @HiveField(8)
  final int type;

  @JsonKey(name: 'audio_url')
  @HiveField(9)
  String? audioUrl;

  @JsonKey(name: 'body_image')
  @HiveField(10)
  final String? bodyImage;

  @JsonKey(name: 'logo')
  @HiveField(11)
  final String logo;

  @JsonKey(name: 'user_id')
  @HiveField(12)
  final String? userId;

  @JsonKey(name: 'card_value')
  @HiveField(13)
  String? cardValue;

  @JsonKey(name: 'featured')
  @HiveField(14)
  final int? featured;

  @HiveField(15)
  String? coins;

  @JsonKey(name: 'attached_brand_cards_coins')
  @HiveField(16)
  String? attachedBrandCardsCoins;

  @JsonKey(name: 'attached_pref_cards_coins')
  @HiveField(17)
  String? attachedPrefCardsCoins;

  @JsonKey(name: 'access_list')
  @HiveField(18)
  List<String>? accessList;

  @JsonKey(name: 'installed_time')
  @HiveField(19)
  final DateTime? installedTime;

  @JsonKey(name: 'attached_card_ids')
  @HiveField(20)
  List<String>? attachedCardIds;

  @JsonKey(name: 'attached_pref_card_ids')
  @HiveField(21)
  List<String>? attachedPrefCardIds;

  @HiveField(22)
  @JsonKey(name: 'answers')
  final List<UserPreference> brandPreferences;

  @HiveField(23)
  final String? domain;

  @JsonKey(name: 'brandId')
  @HiveField(24)
  final int? brandId;

  @JsonKey(name: 'team_id')
  @HiveField(25)
  final int? teamId;

  @JsonKey(name: 'audio_transcription')
  @HiveField(26)
  AudioTranscription? audioTranscription;

  @JsonKey(name: 'gradient')
  @HiveField(27)
  List<String>? gradient;

  @JsonKey(name: 'card_currency')
  @HiveField(28)
  String? cardCurrency;

  CardModel(
      {this.cid,
      this.id,
      required this.brandName,
      this.name,
      required this.image,
      this.categoryId,
      this.brandCategory,
      required this.category,
      required this.type,
      this.audioUrl,
      this.bodyImage,
      required this.logo,
      this.userId,
      this.cardValue,
      this.featured,
      this.coins,
      this.attachedBrandCardsCoins,
      this.attachedPrefCardsCoins,
      this.accessList,
      this.installedTime,
      this.attachedCardIds,
      this.attachedPrefCardIds,
      List<UserPreference>? preferences,
      this.domain,
      this.brandId,
      this.teamId,
      this.gradient,
      this.cardCurrency,
      this.audioTranscription})
      : brandPreferences = preferences ?? [];

  bool get isPreferenceCard => type == 2;// || type == 0;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardModelToJson(this);

  Map<String, dynamic> toInsertJson() => {
        "id": id,
        "audio_url": audioUrl,
        "audio_transcription": audioTranscription?.toJson(),
        "user_id": userId,
        "card_value": cardValue,
        "coins": coins,
        "attached_brand_cards_coins": attachedBrandCardsCoins,
        "attached_pref_cards_coins": attachedPrefCardsCoins,
        "access_list": accessList,
        "installed_time": installedTime?.toIso8601String(),
        "attached_card_ids": attachedCardIds,
        "attached_pref_card_ids": attachedPrefCardIds,
        "answers": brandPreferences,
        "card_currency": cardCurrency
      };

  int get totalCardCoins =>
      ((int.tryParse(attachedBrandCardsCoins ?? "") ?? 0) +
          (int.tryParse(attachedPrefCardsCoins ?? "") ?? 0) +
          (int.tryParse(coins ?? "0") ?? 0));

  @override
  List<Object?> get props => [id];

  CardModel copyWith(
      {int? cid,
      int? id,
      String? brandName,
      String? name,
      String? image,
      String? brandCategory,
      int? categoryId,
      String? category,
      int? type,
      String? audioUrl,
      String? bodyImage,
      String? logo,
      String? userId,
      String? cardValue,
      int? featured,
      String? createdAt,
      String? updatedAt,
      String? coins,
      String? attachedBrandCardsCoins,
      String? attachedPrefCardsCoins,
      List<String>? accessList,
      DateTime? installedTime,
      List<String>? attachedCardIds,
      List<String>? attachedPrefCardIds,
      List<UserPreference>? preferences,
      String? domain,
      int? brandId,
      List<String>? gradient,
      String? cardCurrency,
      int? teamId,
      AudioTranscription? audioTranscription}) {
    return CardModel(
        audioTranscription: audioTranscription ?? this.audioTranscription,
        brandId: brandId ?? this.brandId,
        cid: cid ?? this.cid,
        id: id ?? this.id,
        teamId: teamId ?? this.teamId,
        brandName: brandName ?? this.brandName,
        categoryId: categoryId ?? this.categoryId,
        brandCategory: brandCategory ?? this.brandCategory,
        name: name ?? this.name,
        image: image ?? this.image,
        category: category ?? this.category,
        type: type ?? this.type,
        audioUrl: audioUrl ?? this.audioUrl,
        bodyImage: bodyImage ?? this.bodyImage,
        logo: logo ?? this.logo,
        userId: userId ?? this.userId,
        cardValue: cardValue ?? this.cardValue,
        featured: featured ?? this.featured,
        coins: coins ?? this.coins,
        attachedBrandCardsCoins:
            attachedBrandCardsCoins ?? this.attachedBrandCardsCoins,
        attachedPrefCardsCoins:
            attachedPrefCardsCoins ?? this.attachedPrefCardsCoins,
        accessList: accessList ?? this.accessList,
        installedTime: installedTime ?? this.installedTime,
        attachedCardIds: attachedCardIds ?? this.attachedCardIds,
        attachedPrefCardIds: attachedPrefCardIds ?? this.attachedPrefCardIds,
        preferences: preferences ?? this.brandPreferences,
        domain: domain ?? this.domain,
        cardCurrency: cardCurrency ?? this.cardCurrency,
        gradient: gradient ?? this.gradient);
  }

  Color get primary => HexColor.fromHex(gradient?.first ?? '#090909');

  Color get secondary => HexColor.fromHex(gradient?[1] ?? '#181818');
}
