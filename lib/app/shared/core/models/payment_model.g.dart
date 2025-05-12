// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      id: json['id'] as String,
      initiatedUuid: json['initiated_uuid'] as String?,
      initiatedBrandId: (json['initiated_brand_id'] as num?)?.toInt(),
      toUuid: json['to_uuid'] as String,
      amountRaised: (json['amount_raised'] as num).toDouble(),
      title: json['title'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      currency: json['currency'] as String,
      image: json['image'] as String,
      receiptUrl: json['receipt_url'] as String?,
      amountPayed: (json['amount_payed'] as num?)?.toDouble(),
      description: json['description'] as String?,
      sharedCardId: (json['shared_card_id'] as num?)?.toInt(),
      shareInfoAfterPaymentWithInitiatedUuid:
          json['share_info_after_payment_with_initiated_uuid'] as bool? ??
              false,
    );

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'initiated_uuid': instance.initiatedUuid,
      'initiated_brand_id': instance.initiatedBrandId,
      'to_uuid': instance.toUuid,
      'amount_raised': instance.amountRaised,
      'amount_payed': instance.amountPayed,
      'title': instance.title,
      'description': instance.description,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'currency': instance.currency,
      'image': instance.image,
      'receipt_url': instance.receiptUrl,
      'share_info_after_payment_with_initiated_uuid':
          instance.shareInfoAfterPaymentWithInitiatedUuid,
      'shared_card_id': instance.sharedCardId,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.declined: 'declined',
  PaymentStatus.pending: 'pending',
  PaymentStatus.accepted: 'accepted',
};
