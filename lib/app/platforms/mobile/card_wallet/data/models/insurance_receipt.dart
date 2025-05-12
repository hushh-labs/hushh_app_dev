import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/coverage_details.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/policy_details.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'insurance_receipt.g.dart';

@JsonSerializable()
class InsuranceReceipt {
  @JsonKey(name: 'insurance_type')
  final InsuranceType insuranceType;

  @JsonKey(name: 'message_id')
  final String? messageId;

  @JsonKey(name: 'domain')
  final String? domain;

  @JsonKey(name: 'logo')
  final String? logo;

  @JsonKey(name: 'policy_details')
  final PolicyDetails policyDetails;

  @JsonKey(name: 'coverage_details')
  final CoverageDetails coverageDetails;

  InsuranceReceipt({
    required this.insuranceType,
    this.messageId,
    this.domain,
    this.logo,
    required this.policyDetails,
    required this.coverageDetails,
  });

  factory InsuranceReceipt.fromJson(Map<String, dynamic> json) =>
      _$InsuranceReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$InsuranceReceiptToJson(this);
}
