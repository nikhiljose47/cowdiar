import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'util/const.dart';
import 'screen/Splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cowdiar',
      theme: Constants.lightTheme,
      home:  AnimatedSplashScreen(),
      //home: DetailPage(),
    );
  }
}