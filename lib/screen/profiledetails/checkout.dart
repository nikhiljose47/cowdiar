import 'package:flutter/material.dart';
import 'package:cowdiar/screen/manage/manage.dart';
import 'package:cowdiar/screen/profiledetails/CustomDialog.dart';
import 'package:cowdiar/screen/profiledetails/cart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cowdiar/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class checkout extends StatefulWidget {
  final String checkoutlink ,token;//if you have multiple values add here
  const checkout(this.checkoutlink, this.token, {super.key});
  @override
  _checkoutState createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  WebViewController _controller = WebViewController();

  String url  ="";
  String tokens = "";
  double progress = 0;
  String checkoutpar ="";
  
  void makeRequest() {
    setState(() {
      url = '$baseurl$version/';
      checkoutpar = widget.checkoutlink;
      tokens = widget.token;
    });
    print('$url$checkoutpar&Auth=$tokens');
    _controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
         setState(() {
            this.progress = progress / 100;
          });
      },
      onPageStarted: (String url) {setState(() {
            this.url = 'url';
            var valuetoredirect = this.url.substring(39, 45);
            print(valuetoredirect);
            if (valuetoredirect == 'succes') {
              print('if');
              print(valuetoredirect);
              showDialog(
                  context: context,
                  builder: (context) {
                    Future.delayed(const Duration(seconds: 5), () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const manageorder()));
                    });
                    return const CustomDialog(
                      title: "Order Completed Successfuly!",
                      content:
                      "We've sent you an email with the order information",
                      image: Icon(Icons.check, color: Colors.white,size: 40,),
                      colors: Colors.green,
                    );
                  });
            } else if (valuetoredirect == 'failed') {
              print('elsee');
              print(valuetoredirect);
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const cart()));
                    });
                    return const CustomDialog(
                      title: "Your Order Failed!",
                      content:
                      "Please try again",
                      image: Icon(Icons.cancel, color: Colors.white,size: 40,),
                      colors: Colors.red,
                    );
                  });
            }
          });},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('$url$checkoutpar&Auth=$tokens'));
  }



  @override
  void dispose() {
    super.dispose();

  }

  @override
  void initState() {
    super.initState();
    makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    print("sdsdsdsd");
    print('$url$checkoutpar&Auth=$tokens');

    return Scaffold(
        appBar: AppBar(
          title: const Text("Checkout"),
          centerTitle: true,
        ),
        body: Container(
            child: Column(children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress, valueColor:
                  const AlwaysStoppedAnimation<Color>(primarycolor))
                      : Container()),
              Expanded(
                child: webvies(),
              ),
            ])));
  }
  Widget webvies(){
    return Container(
      child: WebViewWidget(controller: _controller)
    );
  }
}
