import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/csv_parser.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

class AddGoogleSheetsInventoryBottomSheet extends StatefulWidget {
  const AddGoogleSheetsInventoryBottomSheet({super.key});

  @override
  State<AddGoogleSheetsInventoryBottomSheet> createState() =>
      _AddGoogleSheetsInventoryBottomSheetState();
}

class _AddGoogleSheetsInventoryBottomSheetState
    extends State<AddGoogleSheetsInventoryBottomSheet> {
  PlatformFile? selectedFile;
  bool isUploading = false;

  Future<void> _pickFile() async {
    print('📊 [INVENTORY] File picker opened');
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFile = result.files.first;
        });
        print('📊 [INVENTORY] File selected: ${selectedFile!.name}');
        print('📊 [INVENTORY] File size: ${selectedFile!.size} bytes');
        print('📊 [INVENTORY] File extension: ${selectedFile!.extension}');
      } else {
        print('📊 [INVENTORY] No file selected');
      }
    } catch (e) {
      print('📊 [INVENTORY] Error picking file: $e');
      ToastManager(Toast(
              title: 'Error selecting file',
              description: 'Please try again',
              type: ToastificationType.error))
          .show(context);
    }
  }

  Future<void> _uploadFile() async {
    if (selectedFile == null) {
      ToastManager(Toast(
              title: 'No file selected',
              description: 'Please select a file first',
              type: ToastificationType.warning))
          .show(context);
      return;
    }

    // Get agent's hushh_id
    String? hushhId = AppLocalStorage.user?.hushhId;
    if (hushhId == null) {
      ToastManager(Toast(
              title: 'Authentication Error',
              description: 'Please login again',
              type: ToastificationType.error))
          .show(context);
      return;
    }

    print('📊 [INVENTORY] Starting file upload process');
    print('📊 [INVENTORY] Agent Hushh ID: $hushhId');
    setState(() {
      isUploading = true;
    });

    try {
      // Validate file format first
      if (selectedFile!.extension?.toLowerCase() != 'csv') {
        throw Exception('Currently only CSV files are supported. Please convert your file to CSV format.');
      }

      // Get file bytes - try different methods for mobile
      Uint8List? fileBytes;
      
      if (selectedFile!.bytes != null) {
        // Web platform
        fileBytes = selectedFile!.bytes!;
        print('📊 [INVENTORY] Using bytes from web platform');
      } else if (selectedFile!.path != null) {
        // Mobile platform
        print('📊 [INVENTORY] Reading file from path: ${selectedFile!.path}');
        File file = File(selectedFile!.path!);
        fileBytes = await file.readAsBytes();
        print('📊 [INVENTORY] Successfully read ${fileBytes.length} bytes from file');
      } else {
        throw Exception('Unable to access file content');
      }

      print('📊 [INVENTORY] Processing CSV file...');
      
      // Parse CSV file
      List<AgentProductModel> products = await CsvParser.parseCsvFile(
        fileBytes: fileBytes,
        hushhId: hushhId,
      );

      print('📊 [INVENTORY] Parsed ${products.length} products from CSV');

      // Upload products to Supabase agent_products table
      print('📊 [INVENTORY] Uploading products to database...');
      
      // Use the existing insertAgentProductsUseCase from LookBookProductBloc
      final insertResult = await sl<LookBookProductBloc>().insertAgentProductsUseCase(products: products);
      
      await insertResult.fold((error) {
        print('📊 [INVENTORY] Error uploading to database: $error');
        throw Exception('Failed to save products to database: $error');
      }, (success) async {
        print('📊 [INVENTORY] Products uploaded to database successfully');
      });
      ToastManager(Toast(
              title: 'Products uploaded successfully!',
              description: '${products.length} products from ${selectedFile!.name} have been added to your inventory',
              type: ToastificationType.success))
          .show(context);
      
      Navigator.pop(context);
    } catch (e) {
      print('📊 [INVENTORY] Error uploading file: $e');
      ToastManager(Toast(
              title: 'Upload failed',
              description: e.toString(),
              type: ToastificationType.error))
          .show(context);
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('📊 [INVENTORY] Building file upload bottom sheet');
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Upload Your Product Inventory',
                style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 20,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                        color: Color(0xFF4C4C4C), fontFamily: 'Figtree'),
                    children: [
                      TextSpan(
                        text:
                            'Upload your product inventory file (CSV, XLS, XLSX). Make sure your file includes the ',
                      ),
                      TextSpan(
                        text: 'stock_quantity',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1976D2)),
                      ),
                      TextSpan(
                        text: ' field to manage inventory levels.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 20.w,
                child: Divider(
                  color: const Color(0xFF50555C).withOpacity(0.2),
                ),
              ),
              const SizedBox(height: 16),
              
              // Required Format Example
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE9ECEF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Required Format:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF495057),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'product_id,brand,image,price,source,currency,description,product_url,product_title,price_available,additional_image,stock_quantity,additional_description',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6C757D),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // File Selection Area
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFile != null 
                          ? const Color(0xFF28A745) 
                          : const Color(0xFFDEE2E6),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: selectedFile != null 
                        ? const Color(0xFFF8F9FA) 
                        : Colors.white,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        selectedFile != null 
                            ? Icons.check_circle 
                            : Icons.cloud_upload_outlined,
                        size: 40,
                        color: selectedFile != null 
                            ? const Color(0xFF28A745) 
                            : const Color(0xFF6C757D),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedFile != null 
                            ? selectedFile!.name 
                            : 'Tap to select file',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: selectedFile != null 
                              ? const Color(0xFF28A745) 
                              : const Color(0xFF6C757D),
                        ),
                      ),
                      if (selectedFile == null) ...[
                        const SizedBox(height: 4),
                        const Text(
                          'Supports CSV, XLS, XLSX',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6C757D),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Upload Button
              SizedBox(
                height: 46,
                child: HushhLinearGradientButton(
                  text: 'Upload Products',
                  enabled: selectedFile != null && !isUploading,
                  loader: isUploading,
                  onTap: _uploadFile,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
