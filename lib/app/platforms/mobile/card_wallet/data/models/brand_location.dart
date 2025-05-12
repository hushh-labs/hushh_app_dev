import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand_location.g.dart';

@JsonSerializable()
class BrandLocation extends Equatable {
  @JsonKey(name: 'location_id')
  final int? locationId;

  @JsonKey(name: 'brand_id')
  final int brandId;

  @JsonKey(name: 'brand_name')
  final String? brandName;

  @JsonKey(name: 'registered_by')
  final String? registeredBy;

  @JsonKey(name: 'location')
  final dynamic location;

  const BrandLocation({
    this.locationId,
    this.brandName,
    required this.brandId,
    this.registeredBy,
    required this.location,
  });

  @override
  List<Object?> get props => [locationId, brandId, registeredBy, location];

  factory BrandLocation.fromJson(Map<String, dynamic> json) =>
      _$BrandLocationFromJson(json);

  Map<String, dynamic> toJson() => _$BrandLocationToJson(this);
}
