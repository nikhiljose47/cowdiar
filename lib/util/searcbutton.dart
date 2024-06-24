import 'package:flutter/material.dart';
import 'package:cowdiar/services/api.dart';

Widget searchsec(context) {
  return Container(

    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(

              margin: const EdgeInsets.only(top: 10.00, right: 5.00,left: 5.00),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                      style: BorderStyle.solid
                  ),
                  borderRadius:const BorderRadius.all(Radius.circular(10.0)
                  )),


              child:
              Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    GestureDetector(
                      child: Container(

                        padding: const EdgeInsets.only(left: 10.00,right: 65),

                        height: 40,

                        child: const Row(
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              size: 20.0,
                              color: Colors.black,
                            ),
                            Text("  What are you looking for?"),
                          ],
                        ),
                      ),
                      onTap: () {
                        print("Container ");
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.only(right: 10.00),
                        height: 40,
                        child: const Row(
                          children: <Widget>[
                            Icon(
                              Icons.mic,
                              size: 20.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        print("Container was tapped");
                      },
                    ),

                  ]
              ),

            ),
            Container(
              margin: const EdgeInsets.only(top: 5.00, right: 5.00),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: const Text(
                      'cancel',
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
            ),
          ],

        ),

      ],
    ),
  );
}