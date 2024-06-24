import 'package:flutter/material.dart';
import 'package:cowdiar/screen/explore/exploretitle.dart';

class explore extends StatefulWidget {
  const explore({super.key});


  @override
  _exploreState createState() => _exploreState();
}

class _exploreState extends State<explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          searchsec(context),
        ],
      ),
      body: ListView(
          children: [

            marketplacetitle(),


          ]
      ),
    );


    }
}
