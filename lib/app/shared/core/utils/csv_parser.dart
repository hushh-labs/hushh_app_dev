import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:uuid/uuid.dart';

class CsvParser {
  static const List<String> requiredHeaders = [
    'product_id',
    'brand',
    'image',
    'price',
    'source',
    'currency',
    'description',
    'product_url',
    'product_title',
    'price_available',
    'additional_image',
  ];

  static const List<String> optionalHeaders = [
    'additional_description',
  ];

  /// Parse CSV file and return list of AgentProductModel
  static Future<List<AgentProductModel>> parseCsvFile({
    required Uint8List fileBytes,
    required String hushhId,
  }) async {
    try {
      print('📊 [CSV_PARSER] Starting CSV parsing...');
      print('📊 [CSV_PARSER] File size: ${fileBytes.length} bytes');
      print('📊 [CSV_PARSER] Agent Hushh ID: $hushhId');

      // Convert bytes to string
      String csvString = utf8.decode(fileBytes);
      print('📊 [CSV_PARSER] CSV content length: ${csvString.length} characters');

      // Parse CSV
      List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);
      
      if (csvData.isEmpty) {
        throw Exception('CSV file is empty');
      }

      print('📊 [CSV_PARSER] Total rows: ${csvData.length}');

      // Get headers (first row)
      List<String> headers = csvData.first.map((e) => e.toString().toLowerCase().trim()).toList();
      print('📊 [CSV_PARSER] Headers found: $headers');

      // Validate headers
      List<String> missingHeaders = [];
      for (String requiredHeader in requiredHeaders) {
        if (!headers.contains(requiredHeader.toLowerCase())) {
          missingHeaders.add(requiredHeader);
        }
      }

      if (missingHeaders.isNotEmpty) {
        throw Exception('Missing required headers: ${missingHeaders.join(', ')}');
      }

      print('📊 [CSV_PARSER] All required headers found ✅');

      // Parse data rows
      List<AgentProductModel> products = [];
      for (int i = 1; i < csvData.length; i++) {
        try {
          List<dynamic> row = csvData[i];
          
          // Create map from headers and row data
          Map<String, dynamic> rowMap = {};
          for (int j = 0; j < headers.length && j < row.length; j++) {
            rowMap[headers[j]] = row[j];
          }

          // Create product model
          AgentProductModel product = AgentProductModel.fromCsvRow(
            rowMap,
            hushhId,
          );

          products.add(product);
          print('📊 [CSV_PARSER] Parsed product ${i}: ${product.productName}');
        } catch (e) {
          print('📊 [CSV_PARSER] Error parsing row ${i}: $e');
          // Continue with next row instead of failing completely
        }
      }

      print('📊 [CSV_PARSER] Successfully parsed ${products.length} products');
      return products;
    } catch (e) {
      print('📊 [CSV_PARSER] Error parsing CSV: $e');
      rethrow;
    }
  }

  /// Validate CSV format without parsing all data
  static Future<bool> validateCsvFormat(Uint8List fileBytes) async {
    try {
      String csvString = utf8.decode(fileBytes);
      List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);
      
      if (csvData.isEmpty) {
        return false;
      }

      List<String> headers = csvData.first.map((e) => e.toString().toLowerCase().trim()).toList();
      
      // Check if all required headers are present
      for (String requiredHeader in requiredHeaders) {
        if (!headers.contains(requiredHeader.toLowerCase())) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get sample CSV format as string
  static String getSampleCsvFormat() {
    return '''product_id,brand,image,price,source,currency,description,product_url,product_title,price_available,additional_image,additional_description
4000216649,Kirkland Signature,https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400,68,Costco,USD,"Kirkland Signature Men's Sneaker; breathable mesh upper, cushioned sockliner",https://www.costco.com/kirkland-signature-men%27s-sneaker.product.4000216649.html,Kirkland Signature Men's Sneaker,Yes,https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400,Water repellant & stain resistant upper
4000291712,Skechers,https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=400,74.99,Costco,USD,Skechers Women's Virtue Swift Fit Hands Free Shoe; stretch‑fit sock design,https://www.costco.com/skechers-women%27s-virtue-swift-fit-hands-free-shoe.product.4000291712.html,Skechers Women's Virtue Swift Fit Hands Free Shoe,Yes,https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=400,"Memory foam insole, flexible outsole"''';
  }
}
