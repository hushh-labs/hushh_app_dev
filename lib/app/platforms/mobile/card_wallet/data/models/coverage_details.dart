import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/covered_item.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coverage_details.g.dart';

@JsonSerializable()
class CoverageDetails {
  @JsonKey(name: 'covered_items')
  final CoveredItem? coveredItems;

  @JsonKey(name: 'comprehensive_coverage_type_policy')
  final ComprehensiveCoverageTypePolicy comprehensiveCoverageTypePolicy;

  CoverageDetails({
    this.coveredItems,
    this.comprehensiveCoverageTypePolicy = ComprehensiveCoverageTypePolicy.no,
  });

  factory CoverageDetails.fromJson(Map<String, dynamic> json) =>
      _$CoverageDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CoverageDetailsToJson(this);
}
