import 'package:json_annotation/json_annotation.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/offer.dart';

part 'nearby_found_brand.g.dart';

@JsonSerializable(explicitToJson: true)
class NearbyFoundBrandOffers {
  final String name;
  final String address;
  @JsonKey(name: 'logopath')
  final String logoPath;
  @JsonKey(name: 'highlightedoffer')
  final Offer? highlightedOffer;
  final List<Offer>? offers;
  @JsonKey(name: 'brand_id')
  final int brandId;

  NearbyFoundBrandOffers({
    required this.name,
    required this.address,
    required this.logoPath,
    this.highlightedOffer,
    this.offers,
    required this.brandId
  });

  /// Factory method to generate an instance from JSON
  factory NearbyFoundBrandOffers.fromJson(Map<String, dynamic> json) =>
      _$NearbyFoundBrandOffersFromJson(json);

  /// Method to convert the instance to JSON
  Map<String, dynamic> toJson() => _$NearbyFoundBrandOffersToJson(this);
}
