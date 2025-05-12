import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class ReceiptScanBottomSheet extends StatefulWidget {
  const ReceiptScanBottomSheet({Key? key}) : super(key: key);

  @override
  _ReceiptScanBottomSheetState createState() => _ReceiptScanBottomSheetState();
}

class _ReceiptScanBottomSheetState extends State<ReceiptScanBottomSheet> {
  // CameraController? _controller;
  final docController = DocumentScannerController();

  @override
  void initState() {
    super.initState();
    // _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras[0];
    // _controller = CameraController(firstCamera, ResolutionPreset.high);
    // await _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    docController.dispose();
    // _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Text(
                'Scan your Receipt',
                style: TextStyle(
                  color: Color(0xff181941),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: DocumentScanner(
                initialCameraLensDirection: CameraLensDirection.back,
                controller: docController,
                onSave: (Uint8List imageBytes) {
                  Navigator.pop(context);
                  sl<SharedAssetsReceiptsBloc>()
                      .add(ShareReceiptsAsImageEvent(context, imageBytes));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
