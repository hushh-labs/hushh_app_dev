import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_app_bar.dart';

class TextViewerPage extends StatefulWidget {
  TextViewerPage();

  @override
  _TextViewerPageState createState() => _TextViewerPageState();
}

class _TextViewerPageState extends State<TextViewerPage> {
  @override
  Widget build(BuildContext context) {
    final text = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: ReceiptRadarAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(text),
      ),
    );
  }
}
