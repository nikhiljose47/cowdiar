import 'package:flutter/material.dart';


Widget pagetilesec() {
  return Container(
    padding: const EdgeInsets.only(left: 0.00),
    child: const Center(child: Text("Inbox")),
  );
}
// title right
Widget rightsec(){
  return Container(
      child:
      Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.list,      size: 20.0,
            color: Colors.black),
            onPressed: () {
            },
          ),
        ],
      ),


  );
}
