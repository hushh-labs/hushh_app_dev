// app/shared/core/components/web_viewer.dart
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

class LegalWebViewPage extends StatefulWidget {
  final String url;
  const LegalWebViewPage({
    super.key,
    this.url = 'https://hushh-tech-legal.replit.app/',
  });

  @override
  State<LegalWebViewPage> createState() => _LegalWebViewPageState();
}

class _LegalWebViewPageState extends State<LegalWebViewPage> {
  late final WebViewControllerPlus _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewControllerPlus()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hushh Legal Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
