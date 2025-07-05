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
  final int stockQuantity;
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
      this.stockQuantity = 0,
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
    int stockQuantityIndex =
        csv[0].indexOf(columnsMap['stock_quantity_column']);
    List<AgentProductModel> products = [];
    for (int i = 1; i < csv.length; i++) {
      double productPrice = 420;
      int stockQuantity = 0;

      try {
        productPrice = double.parse(csv[i][priceIndex].toString());
      } catch (e) {
        print("Error parsing product price for row $i: $e");
      }

      try {
        if (stockQuantityIndex != -1 && stockQuantityIndex < csv[i].length) {
          stockQuantity = int.parse(csv[i][stockQuantityIndex].toString());
        }
      } catch (e) {
        print("Error parsing stock quantity for row $i: $e");
      }

      products.add(AgentProductModel(
        productCurrency:
            sl<HomePageBloc>().currency?.shorten() ?? defaultCurrency.shorten(),
        productDescription: csv[i][descriptionIndex].toString(),
        productImage: csv[i][imageIndex].toString(),
        productName: csv[i][nameIndex].toString(),
        productSkuUniqueId: csv[i][skuIndex].toString(),
        productPrice: productPrice,
        stockQuantity: stockQuantity,
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
      'stockQuantity': stockQuantity,
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
        stockQuantity: json['stock_quantity'] ?? 0,
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
        stockQuantity: json['stock_quantity'] ?? 0,
        productId: json['product_id'],
        hushhId: json['hushh_id'],
        lookbookId: json['lookbook_id']);
  }

  factory AgentProductModel.fromCachedInventoryJson(Map<String, dynamic> json) {
    print(
        '📊 [MODEL] Parsing product: ${json['productName']} - ${json['productPrice']}');
    return AgentProductModel(
        productCurrency: json['productCurrency'] ?? 'INR',
        productImage: json['productImage'] ?? '',
        productName: json['productName'] ?? 'N/A',
        productDescription: json['productDescription'] ?? 'N/A',
        productSkuUniqueId: json['productSkuUniqueId']?.toString() ?? '',
        productPrice: (json['productPrice'] is num)
            ? json['productPrice'].toDouble()
            : 0.0,
        stockQuantity: json['stock_quantity'] ?? 0,
        productId: json['productId'],
        hushhId: json['hushh_id'],
        createdAt:
            json['addedAt'] != null ? DateTime.tryParse(json['addedAt']) : null,
        lookbookId: json['lookbook_id']);
  }

  // Factory method to create from CSV row
  factory AgentProductModel.fromCsvRow(
    Map<String, dynamic> csvRow,
    String hushhId,
  ) {
    // Get a working placeholder image based on product type
    String getPlaceholderImage(String productName) {
      final name = productName.toLowerCase();
      if (name.contains('sneaker') || name.contains('shoe')) {
        return 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=400&fit=crop';
      } else if (name.contains('sunglasses')) {
        return 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400&h=400&fit=crop';
      } else if (name.contains('boot')) {
        return 'https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=400&h=400&fit=crop';
      } else if (name.contains('slip-on')) {
        return 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=400&h=400&fit=crop';
      } else {
        return 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop';
      }
    }

    String productName = csvRow['product_title']?.toString() ?? 'N/A';
    String originalImage = csvRow['image']?.toString() ?? '';

    // Use placeholder if original image is from costco.com (which are fake)
    String finalImage = originalImage.contains('costco.com')
        ? getPlaceholderImage(productName)
        : originalImage;

    return AgentProductModel(
      productImage: finalImage,
      productName: productName,
      productSkuUniqueId: csvRow['product_id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      productPrice: double.tryParse(csvRow['price']?.toString() ?? '0') ?? 0,
      productCurrency: csvRow['currency']?.toString() ?? 'USD',
      productDescription: csvRow['description']?.toString() ?? '',
      stockQuantity:
          int.tryParse(csvRow['stock_quantity']?.toString() ?? '0') ?? 0,
      hushhId: hushhId,
      productId: DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          (csvRow['product_id']?.toString() ?? ''),
    );
  }
}
