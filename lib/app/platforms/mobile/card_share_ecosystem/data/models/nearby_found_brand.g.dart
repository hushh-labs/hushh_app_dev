// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_found_brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyFoundBrandOffers _$NearbyFoundBrandOffersFromJson(
        Map<String, dynamic> json) =>
    NearbyFoundBrandOffers(
      name: json['name'] as String,
      address: json['address'] as String,
      logoPath: json['logopath'] as String,
      highlightedOffer: json['highlightedoffer'] == null
          ? null
          : Offer.fromJson(json['highlightedoffer'] as Map<String, dynamic>),
      offers: (json['offers'] as List<dynamic>?)
          ?.map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList(),
      brandId: (json['brand_id'] as num).toInt(),
    );

Map<String, dynamic> _$NearbyFoundBrandOffersToJson(
        NearbyFoundBrandOffers instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'logopath': instance.logoPath,
      'highlightedoffer': instance.highlightedOffer?.toJson(),
      'offers': instance.offers?.map((e) => e.toJson()).toList(),
      'brand_id': instance.brandId,
    };
