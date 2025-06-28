import 'package:equatable/equatable.dart';

class AgentProductModel extends Equatable {
  final String productId;
  final String hushhId;
  final String? lookbookId;
  final String? productName;
  final String? productDescription;
  final String? productImage;
  final double? productPrice;
  final String? productCurrency;
  final String? productSkuUniqueId;
  final String? addedAt;

  const AgentProductModel({
    required this.productId,
    required this.hushhId,
    this.lookbookId,
    this.productName,
    this.productDescription,
    this.productImage,
    this.productPrice,
    this.productCurrency = 'USD',
    this.productSkuUniqueId,
    this.addedAt,
  });

  factory AgentProductModel.fromJson(Map<String, dynamic> json) {
    return AgentProductModel(
      productId: json['productId'] ?? '',
      hushhId: json['hushh_id'] ?? '',
      lookbookId: json['lookbook_id'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      productImage: json['productImage'],
      productPrice: json['productPrice']?.toDouble(),
      productCurrency: json['productCurrency'] ?? 'USD',
      productSkuUniqueId: json['productSkuUniqueId'],
      addedAt: json['addedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'hushh_id': hushhId,
      'lookbook_id': lookbookId,
      'productName': productName,
      'productDescription': productDescription,
      'productImage': productImage,
      'productPrice': productPrice,
      'productCurrency': productCurrency,
      'productSkuUniqueId': productSkuUniqueId,
      'addedAt': addedAt,
    };
  }

  // Factory method to create from CSV row
  factory AgentProductModel.fromCsvRow(
    Map<String, dynamic> csvRow, 
    String hushhId,
  ) {
    return AgentProductModel(
      productId: csvRow['product_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      hushhId: hushhId,
      productName: csvRow['product_title']?.toString(),
      productDescription: csvRow['description']?.toString(),
      productImage: csvRow['image']?.toString(),
      productPrice: double.tryParse(csvRow['price']?.toString() ?? '0'),
      productCurrency: csvRow['currency']?.toString() ?? 'USD',
      productSkuUniqueId: csvRow['product_id']?.toString(),
      addedAt: DateTime.now().toIso8601String(),
    );
  }

  AgentProductModel copyWith({
    String? productId,
    String? hushhId,
    String? lookbookId,
    String? productName,
    String? productDescription,
    String? productImage,
    double? productPrice,
    String? productCurrency,
    String? productSkuUniqueId,
    String? addedAt,
  }) {
    return AgentProductModel(
      productId: productId ?? this.productId,
      hushhId: hushhId ?? this.hushhId,
      lookbookId: lookbookId ?? this.lookbookId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      productCurrency: productCurrency ?? this.productCurrency,
      productSkuUniqueId: productSkuUniqueId ?? this.productSkuUniqueId,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        hushhId,
        lookbookId,
        productName,
        productDescription,
        productImage,
        productPrice,
        productCurrency,
        productSkuUniqueId,
        addedAt,
      ];
}
