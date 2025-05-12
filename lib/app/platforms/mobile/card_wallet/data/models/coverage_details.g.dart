// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coverage_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoverageDetails _$CoverageDetailsFromJson(Map<String, dynamic> json) =>
    CoverageDetails(
      coveredItems: json['covered_items'] == null
          ? null
          : CoveredItem.fromJson(json['covered_items'] as Map<String, dynamic>),
      comprehensiveCoverageTypePolicy: $enumDecodeNullable(
              _$ComprehensiveCoverageTypePolicyEnumMap,
              json['comprehensive_coverage_type_policy']) ??
          ComprehensiveCoverageTypePolicy.no,
    );

Map<String, dynamic> _$CoverageDetailsToJson(CoverageDetails instance) =>
    <String, dynamic>{
      'covered_items': instance.coveredItems,
      'comprehensive_coverage_type_policy':
          _$ComprehensiveCoverageTypePolicyEnumMap[
              instance.comprehensiveCoverageTypePolicy]!,
    };

const _$ComprehensiveCoverageTypePolicyEnumMap = {
  ComprehensiveCoverageTypePolicy.yes: 'yes',
  ComprehensiveCoverageTypePolicy.no: 'no',
};
