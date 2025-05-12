import 'dart:convert';

import 'package:hushh_app/currency_converter/currency.dart';
import 'package:equatable/equatable.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'receipt_model.g.dart';

@JsonSerializable()
class ReceiptModel extends Equatable {
  @JsonKey(name: 'user_id')
  final String? userId;

  @JsonKey(name: 'time_stamp')
  final String? timeStamp;

  final String? brand;
  final String? location;

  @JsonKey(name: 'purchase_category')
  final String? purchaseCategory;

  @JsonKey(name: 'brand_category')
  final String? brandCategory;

  @JsonKey(name: 'receipt_date', fromJson: _dateTimeFromJson)
  final DateTime date;

  final String? currency;
  final String? filename;

  @JsonKey(name: 'payment_method')
  final String? paymentMethod;

  final String? logo;
  final String? metadata;

  @JsonKey(name: 'session_id')
  final String? sessionId;

  @JsonKey(name: 'message_id')
  final String? messageId;

  @JsonKey(name: 'total_cost')
  final double? totalCost;

  @JsonKey(name: 'inr_total_cost')
  final double? inrTotalCost;

  @JsonKey(name: 'usd_total_cost')
  final double? usdTotalCost;

  final String? company;

  @JsonKey(name: 'attachment_id')
  final String? attachmentId;

  final String? body;

  @JsonKey(name: 'attachment_extension')
  final String? attachmentExtension;

  @JsonKey(name: 'receipt_id')
  final int? receiptId;

  @JsonKey(name: 'structured_receipt_date')
  final String? structuredReceiptDate;

  final String? email;

  @JsonKey(name: 'document_id')
  final int? documentId;

  @JsonKey(name: 'due_date')
  final String? dueDate;

  @JsonKey(name: 'invoice_date')
  final String? invoiceDate;

  @JsonKey(name: 'total_amount')
  final String? totalAmount;

  @JsonKey(name: 'total_tax_amount')
  final String? totalTaxAmount;

  @JsonKey(name: 'receiver_name')
  final String? receiverName;

  @JsonKey(name: 'invoice_id')
  final String? invoiceId;

  @JsonKey(name: 'document_currency')
  final String? documentCurrency;

  @JsonKey(name: 'receiver_address')
  final String? receiverAddress;

  @JsonKey(name: 'invoice_type')
  final String? invoiceType;

  @JsonKey(name: 'supplier_name')
  final String? supplierName;

  @JsonKey(name: 'payment_terms')
  final String? paymentTerms;

  @JsonKey(name: 'line_item')
  final String? lineItem;

  @JsonKey(name: 'line_item_description')
  final String? lineItemDescription;

  @JsonKey(name: 'line_item_quantity')
  final String? lineItemQuantity;

  @JsonKey(name: 'line_item_amount')
  final String? lineItemAmount;

  @JsonKey(name: 'line_item_unit_price')
  final String? lineItemUnitPrice;

  @JsonKey(name: 'raw_text')
  final String? rawText;

  @JsonKey(name: 'categorised_data')
  final String? categorisedData;

  ReceiptModel({
    this.userId,
    this.timeStamp,
    this.brand,
    this.location,
    this.purchaseCategory,
    this.brandCategory,
    required this.date,
    this.currency,
    this.filename,
    this.paymentMethod,
    this.logo,
    this.metadata,
    this.sessionId,
    this.messageId,
    this.totalCost,
    this.inrTotalCost,
    this.usdTotalCost,
    this.company,
    this.attachmentId,
    this.body,
    this.categorisedData,
    this.attachmentExtension,
    this.receiptId,
    this.structuredReceiptDate,
    this.email,
    this.documentId,
    this.dueDate,
    this.invoiceDate,
    this.totalAmount,
    this.totalTaxAmount,
    this.receiverName,
    this.invoiceId,
    this.documentCurrency,
    this.receiverAddress,
    this.invoiceType,
    this.supplierName,
    this.paymentTerms,
    this.lineItem,
    this.lineItemDescription,
    this.lineItemQuantity,
    this.lineItemAmount,
    this.lineItemUnitPrice,
    this.rawText,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$ReceiptModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptModelToJson(this);

  static DateTime _dateTimeFromJson(String? date) {
    // Default to DateTime(1800) if null or invalid
    return DateTime.tryParse(date ?? '') ?? DateTime(1800);
  }

  double? get totalDocumentAiCost {
    try {
      return double.tryParse(
          jsonDecode(totalAmount ?? '')[0]['normalizedValue']['text']);
    } catch (_) {
      return null;
    }
  }

  String? get documentAiCurrency {
    try {
      return jsonDecode(documentCurrency ?? '')[0]['normalizedValue']['text'];
    } catch (_) {
      return null;
    }
  }

  String get finalBrand =>
      brand ?? (supplierName != null?(jsonDecode(supplierName!)[0]['mention_text']):null) ?? company ?? 'N/A';

  String get finalLocation =>
      location ??
      (receiverAddress != null
          ? (jsonDecode(receiverAddress!)[0]['mention_text'])
          : null) ??
      'N/A';

  DateTime get finalDate {
    return date.year == 1800
        ? (invoiceDate != null
            ? DateFormat('yyyy-MM-dd')
                .parse(jsonDecode(invoiceDate!)[0]['normalizedValue']['text'])
            : date)
        : date;
  }

  double? get finalCost => totalDocumentAiCost ?? totalCost ?? 0;

  String get finalTitle => name.replaceAll('_null', '');

  /// Gets the currency object.
  Currency get currencyObj {
    if (documentAiCurrency != null) {
      switch (documentAiCurrency) {
        case 'INR':
          return Currency.inr;
        case 'USD':
          return Currency.usd;
        case 'EUR':
          return Currency.eur;
      }
    }

    switch (currency) {
      case 'INR':
        return Currency.inr;
      case 'USD':
        return Currency.usd;
      case 'EUR':
        return Currency.eur;
    }
    return sl<HomePageBloc>().currency;
  }

  /// Gets the name, defaults to 'N/A' if `filename` is null.
  String get name {
    String n = filename ??
      (supplierName != null
          ? (jsonDecode(supplierName!)[0]['mention_text'])
          : null) ?? finalBrand;
    if(n == 'N/A') {
    }
    return n;
  }

  @override
  List<Object?> get props => [receiptId];
}
