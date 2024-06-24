import 'package:flutter/material.dart';
import 'package:cowdiar/services/api.dart';

class Cat {
  String? name;
  String? img;

  Cat(
      { this.name,  this.img});
}

class catDetailPage extends StatelessWidget {
  final Cat? cat;
  const catDetailPage({ super.key,  this.cat});
  @override
  Widget build(BuildContext context) {
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 80.0),
        const Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 40.0,
        ),
        const SizedBox(
          width: 90.0,
          child: Divider(color: primarycolor),
        ),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.only(bottom: 20.00),
          child: Text(
            cat.name,
            style: const TextStyle(color: Colors.white, fontSize: 45.0),
          ),
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[

        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 4.0,
          top: 20.0,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(

              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        )
      ],
    );

    final bottomContentText = Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.00),
          child: Center(
            child: Text(
              cat.name,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ],
    );


    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[topContent, bottomContentText],
        ),
      ),
    );
  }
}