import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class GoogleAuthWebView extends StatefulWidget {
  final Function(String?, String?) onAuthComplete;

  const GoogleAuthWebView({Key? key, required this.onAuthComplete})
      : super(key: key);

  @override
  State<GoogleAuthWebView> createState() => _GoogleAuthWebViewState();
}

class _GoogleAuthWebViewState extends State<GoogleAuthWebView> {
  late final WebViewControllerPlus _controller;
  final String authUrl =
      'https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=53407187172-t1ojln3gadj5pvd10bga2gjevvnt93lq.apps.googleusercontent.com&redirect_uri=https://hushh-receipt-radar-redirect-uri.hf.space/receipt_radar/callback&scope=openid%20profile%20email%20https://www.googleapis.com/auth/gmail.readonly&access_type=offline&prompt=select_account';

  @override
  void initState() {
    super.initState();
    _controller = WebViewControllerPlus()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          if (url.startsWith(
              'https://hushh-receipt-radar-redirect-uri.hf.space')) {
            extractAccessToken();
          }
        },
      ))
      ..loadRequest(Uri.parse(authUrl))
      ..setUserAgent('random');
  }

  Future<void> handleRedirectUrl(String url) async {
    try {
      // Wait briefly to ensure the page content is loaded
      await Future.delayed(const Duration(milliseconds: 500));
      extractAccessToken();
    } catch (e) {
      widget.onAuthComplete(null, null);
    }
  }

  Future<void> extractAccessToken() async {
    try {
      // Get the page content
      final String? pageContent =
          await _controller.runJavaScriptReturningResult(
        'document.body.textContent',
      ) as String?;

      if (pageContent != null) {
        try {
          var jsonResponse;
          if(Platform.isIOS) {
            jsonResponse = jsonDecode(pageContent);
          } else {
            jsonResponse = jsonDecode(jsonDecode(pageContent));
          }
          final String? email = jsonResponse['email'];
          final String? accessToken = jsonResponse['access_token'];

          if (email != null) {
            widget.onAuthComplete(email, accessToken);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
            return;
          }
        } catch (e) {
        }
      }
    } catch (e) {
      widget.onAuthComplete(null, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onAuthComplete(null, null);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
