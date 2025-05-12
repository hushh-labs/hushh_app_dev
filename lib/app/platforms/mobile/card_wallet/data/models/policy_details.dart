import 'package:json_annotation/json_annotation.dart';
part 'policy_details.g.dart';

@JsonSerializable()
class PolicyDetails {
  @JsonKey(name: 'policyholder_name')
  final String? policyholderName;

  @JsonKey(name: 'policy_number')
  final String? policyNumber;

  @JsonKey(name: 'insurance_start_date')
  final String? insuranceStartDate;

  @JsonKey(name: 'insurance_end_date')
  final String? insuranceEndDate;

  @JsonKey(name: 'premium_amount')
  final String? premiumAmount;

  @JsonKey(name: 'payment_frequency')
  final String? paymentFrequency;

  PolicyDetails({
    this.policyholderName,
    this.policyNumber,
    this.insuranceStartDate,
    this.insuranceEndDate,
    this.premiumAmount,
    this.paymentFrequency,
  });

  factory PolicyDetails.fromJson(Map<String, dynamic> json) =>
      _$PolicyDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyDetailsToJson(this);
}
