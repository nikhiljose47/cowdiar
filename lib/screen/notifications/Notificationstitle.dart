import 'package:flutter/material.dart';
import 'package:cowdiar/services/api.dart';


Widget pagetilesec() {
  return Container(
    padding: const EdgeInsets.only(left: 0.00),
    child: const Center(child: Text("Notifications")),
  );
}
// title right
Widget rightsec(){
  return Container(
    padding: const EdgeInsets.only(right: 5.0),
    child:
    Row(
      children: <Widget>[
        GestureDetector(
          child: const Text(
            'Edit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primarycolor,
            ),
          ),
          onTap: () {
            print("home");
          },
        ),
      ],
    ),


  );
}
