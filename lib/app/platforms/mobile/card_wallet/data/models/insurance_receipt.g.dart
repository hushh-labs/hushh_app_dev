// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsuranceReceipt _$InsuranceReceiptFromJson(Map<String, dynamic> json) =>
    InsuranceReceipt(
      insuranceType:
          $enumDecode(_$InsuranceTypeEnumMap, json['insurance_type']),
      messageId: json['message_id'] as String?,
      domain: json['domain'] as String?,
      logo: json['logo'] as String?,
      policyDetails: PolicyDetails.fromJson(
          json['policy_details'] as Map<String, dynamic>),
      coverageDetails: CoverageDetails.fromJson(
          json['coverage_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InsuranceReceiptToJson(InsuranceReceipt instance) =>
    <String, dynamic>{
      'insurance_type': _$InsuranceTypeEnumMap[instance.insuranceType]!,
      'message_id': instance.messageId,
      'domain': instance.domain,
      'logo': instance.logo,
      'policy_details': instance.policyDetails,
      'coverage_details': instance.coverageDetails,
    };

const _$InsuranceTypeEnumMap = {
  InsuranceType.travel: 'travel',
  InsuranceType.health: 'health',
  InsuranceType.term: 'term',
  InsuranceType.vehicle: 'vehicle',
  InsuranceType.property: 'property',
  InsuranceType.liability: 'liability',
  InsuranceType.life: 'life',
  InsuranceType.business: 'business',
  InsuranceType.others: 'others',
};
