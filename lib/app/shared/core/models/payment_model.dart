import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'initiated_uuid')
  final String? initiatedUuid;

  @JsonKey(name: 'initiated_brand_id')
  final int? initiatedBrandId;

  @JsonKey(name: 'to_uuid')
  final String toUuid;

  @JsonKey(name: 'amount_raised')
  final double amountRaised;

  @JsonKey(name: 'amount_payed')
  double? amountPayed;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'status')
  PaymentStatus status;

  @JsonKey(name: 'currency')
  String currency;

  @JsonKey(name: 'image')
  String image;

  @JsonKey(name: 'receipt_url')
  String? receiptUrl;

  @JsonKey(name: 'share_info_after_payment_with_initiated_uuid')
  bool shareInfoAfterPaymentWithInitiatedUuid;

  @JsonKey(name: 'shared_card_id')
  int? sharedCardId;

  PaymentModel(
      {required this.id,
      this.initiatedUuid,
      this.initiatedBrandId,
      required this.toUuid,
      required this.amountRaised,
      required this.title,
      required this.status,
      required this.currency,
      required this.image,
      this.receiptUrl,
      this.amountPayed,
      this.description,
      this.sharedCardId,
      this.shareInfoAfterPaymentWithInitiatedUuid = false});

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);

  PaymentModel copyWith(
      {String? id,
      String? initiatedUuid,
      int? initiatedBrandId,
      String? toUuid,
      double? amountRaised,
      double? amountPayed,
      String? title,
      String? description,
      String? currency,
      String? image,
      String? receiptUrl,
      PaymentStatus? status,
      bool? shareInfoAfterPaymentWithInitiatedUuid,
      int? sharedCardId}) {
    return PaymentModel(
        id: id ?? this.id,
        initiatedUuid: initiatedUuid ?? this.initiatedUuid,
        initiatedBrandId: initiatedBrandId ?? this.initiatedBrandId,
        toUuid: toUuid ?? this.toUuid,
        amountRaised: amountRaised ?? this.amountRaised,
        amountPayed: amountPayed ?? this.amountPayed,
        title: title ?? this.title,
        currency: currency ?? this.currency,
        image: image ?? this.image,
        receiptUrl: receiptUrl ?? this.receiptUrl,
        description: description ?? this.description,
        status: status ?? this.status,
        sharedCardId: sharedCardId ?? this.sharedCardId,
        shareInfoAfterPaymentWithInitiatedUuid:
            shareInfoAfterPaymentWithInitiatedUuid ??
                this.shareInfoAfterPaymentWithInitiatedUuid);
  }
}
