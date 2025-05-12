import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class AgentProductModel {
  final String productImage;
  final String productName;
  final String productSkuUniqueId;
  final double productPrice;
  final String productCurrency;
  final String productDescription;
  final String? lookbookId;
  final String? productId;
  final String? hushhId;
  final DateTime? createdAt;

  AgentProductModel(
      {required this.productImage,
      required this.productName,
      required this.productSkuUniqueId,
      required this.productPrice,
      required this.productCurrency,
      required this.productDescription,
      this.lookbookId,
      this.productId,
      this.createdAt,
      this.hushhId});

  static List<AgentProductModel> fromCsv(
      List<List<dynamic>> csv, Map<String, String> columnsMap) {
    int imageIndex = csv[0].indexOf(columnsMap['product_image_column']);
    int nameIndex = csv[0].indexOf(columnsMap['product_name_column']);
    int skuIndex = csv[0].indexOf(columnsMap['product_sku_unique_id_column']);
    int priceIndex = csv[0].indexOf(columnsMap['product_price_column']);
    int descriptionIndex =
        csv[0].indexOf(columnsMap['product_description_column']);
    List<AgentProductModel> products = [];
    for (int i = 1; i < csv.length; i++) {
      double productPrice = 420;

      try {
        productPrice = double.parse(csv[i][priceIndex].toString());
      } catch (e) {
        print("Error parsing product price for row $i: $e");
      }
      products.add(AgentProductModel(
        productCurrency: sl<HomePageBloc>().currency?.shorten() ??
            defaultCurrency.shorten(),
        productDescription: csv[i][descriptionIndex].toString(),
        productImage: csv[i][imageIndex].toString(),
        productName: csv[i][nameIndex].toString(),
        productSkuUniqueId: csv[i][skuIndex].toString(),
        productPrice: productPrice,
      ));
    }

    return products;
  }

  Map<String, dynamic> toJson(
      {String? lookbookId, String? productId, String? hushhId}) {
    return {
      'productCurrency': productCurrency,
      'productImage': productImage,
      'productName': productName,
      'productDescription': productDescription,
      'productSkuUniqueId': productSkuUniqueId,
      'productPrice': productPrice,
      'lookbook_id': lookbookId ?? this.lookbookId,
      'productId': productId ?? this.productId,
      'hushh_id': hushhId ?? this.hushhId
    };
  }

  factory AgentProductModel.fromJson(Map<String, dynamic> json) {
    return AgentProductModel(
        productCurrency: json['productCurrency'],
        productImage: json['productImage'],
        productName: json['productName'],
        productDescription: json['productDescription'],
        productSkuUniqueId: json['productSkuUniqueId'],
        productPrice: json['productPrice'].toDouble(),
        productId: json['productId'],
        hushhId: json['hushh_id'],
        lookbookId: json['lookbook_id']);
  }

  factory AgentProductModel.fromInventoryJson(Map<String, dynamic> json) {
    return AgentProductModel(
        productCurrency: json['product_currency_identifier'] ?? 'INR',
        productImage: json['product_image_identifier'] ?? '',
        productName: json['product_name_identifier'] ?? 'N/A',
        productDescription: json['product_description_identifier'] ?? 'N/A',
        productSkuUniqueId:
            json['product_sku_unique_id_identifier']?.toString() ?? '',
        productPrice: json['product_price_identifier']?.toDouble() ?? 0,
        productId: json['product_id'],
        hushhId: json['hushh_id'],
        lookbookId: json['lookbook_id']);
  }

  factory AgentProductModel.fromCachedInventoryJson(Map<String, dynamic> json) {
    return AgentProductModel(
        productCurrency: json['product_currency'] ?? 'INR',
        productImage: json['product_image'] ?? '',
        productName: json['product_name'] ?? 'N/A',
        productDescription: json['product_description'] ?? 'N/A',
        productSkuUniqueId: json['product_sku_unique_id']?.toString() ?? json['product_sku']?.toString() ?? '',
        productPrice: double.tryParse(json['product_price'] ?? "") ?? 0,
        productId: json['product_id'],
        hushhId: json['hushh_id'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        lookbookId: json['lookbook_id']);
  }
}
