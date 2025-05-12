import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_app_bar.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class WebViewerPage extends StatefulWidget {
  const WebViewerPage({super.key});

  @override
  State<WebViewerPage> createState() => _WebViewerPageState();
}

class _WebViewerPageState extends State<WebViewerPage> {
  WebViewControllerPlus? _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final html = ModalRoute.of(context)!.settings.arguments as String;
      _controller = WebViewControllerPlus()
        ..loadHtmlString(html)
        ..setJavaScriptMode(JavaScriptMode.unrestricted);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReceiptRadarAppBar(),
      body: _controller == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : WebViewWidget(
              controller: _controller!,
            ),
    );
  }
}
