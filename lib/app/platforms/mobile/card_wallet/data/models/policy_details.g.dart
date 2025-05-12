// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolicyDetails _$PolicyDetailsFromJson(Map<String, dynamic> json) =>
    PolicyDetails(
      policyholderName: json['policyholder_name'] as String?,
      policyNumber: json['policy_number'] as String?,
      insuranceStartDate: json['insurance_start_date'] as String?,
      insuranceEndDate: json['insurance_end_date'] as String?,
      premiumAmount: json['premium_amount'] as String?,
      paymentFrequency: json['payment_frequency'] as String?,
    );

Map<String, dynamic> _$PolicyDetailsToJson(PolicyDetails instance) =>
    <String, dynamic>{
      'policyholder_name': instance.policyholderName,
      'policy_number': instance.policyNumber,
      'insurance_start_date': instance.insuranceStartDate,
      'insurance_end_date': instance.insuranceEndDate,
      'premium_amount': instance.premiumAmount,
      'payment_frequency': instance.paymentFrequency,
    };
