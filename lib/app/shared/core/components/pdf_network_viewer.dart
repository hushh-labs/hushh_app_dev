import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_app_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFNetworkViewerPage extends StatefulWidget {
  const PDFNetworkViewerPage();

  @override
  _PDFNetworkViewerPageState createState() => _PDFNetworkViewerPageState();
}

class _PDFNetworkViewerPageState extends State<PDFNetworkViewerPage> {
  @override
  Widget build(BuildContext context) {
    final src = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: const ReceiptRadarAppBar(),
      body: SfPdfViewer.network(src),
    );
  }
}
