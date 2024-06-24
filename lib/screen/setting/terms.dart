import 'package:flutter/material.dart';
import 'package:cowdiar/services/api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class terms extends StatefulWidget {
  const terms({super.key});

  @override
  termsState createState() => termsState();
}

class termsState extends State<terms> {
  final _controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse(baseurl+termslink));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text("Terms of Service",style: TextStyle(
          color: Colors.black,
        ),),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: _controller),
    );

  }
}