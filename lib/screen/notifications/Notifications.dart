import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cowdiar/screen/notifications/notificationfilter.dart';
import 'package:cowdiar/services/api.dart';
import 'package:cowdiar/util/mail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
class Notifications extends StatefulWidget {
  const Notifications({super.key, this.title});
  final String? title;
  @override
  _NotificationspageState createState() => _NotificationspageState();
}

class _NotificationspageState extends State<Notifications> {
  final int _selectedIndex = 0;
  String token = "";
  List<NotificationsArr> listSCArr = [];
  String? choice;
  String items="all";
  var loading = false;

  Future<Null> getData(String choice) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    print(token);

    setState(() {
      loading = true;
    });
    final responseData = await http.get(
        Uri.parse(baseurl + version + notificationlink), headers: {'Auth': token});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listsCArr = jsonDecode(data)['content']['notificationsArr'] as List;

      setState(() {
        for (Map i in listsCArr) {
          listSCArr.add(NotificationsArr.fromMap(i as Map<String, dynamic>));
        }
        loading = false;
      });
    }
    }


  Future<Null> action(String messageGroupId, String actionval) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    print("index");
    print(token);
    setState(() {
      loading = true;
    });
    print(messageGroupId);

    final responseData = await http.post( Uri.parse(baseurl + version  + notificationactionlink ),
        body: {"notification_ids": messageGroupId,
          "action_status":actionval},
        headers: {'Auth': token}
    );
    final data = responseData.body;
    var value = jsonDecode(data)['status'];
    var message = jsonDecode(data)['message'];
    print(value);
    if(value=="1"){
      loginToast(message);
      listSCArr.clear();
      getData(choice);
    }
    else{
      loginToast(message);
    }
    setState(() {
    });
  }
  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: primarycolor,
        textColor: Colors.white);
  }
  void choiceAction(String choice){
    if(choice == Constants.unread){
      listSCArr.clear();
      getData(choice);
    }else if(choice == Constants.read){
      listSCArr.clear();
      getData(choice);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(choice);

  }
  Widget slideRightBackground() {
    return Container(
      color: primarycolor,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Text(
              "archive",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
  Widget slideLeftBackground() {
    return Container(
      color: primarycolor,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 0.0,
        title: SizedBox(
            width: MediaQuery.of(context).size.width/1.7,
            child: const Center(child: Text("Notification"))
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice!),
                );
              }).toList();
            },
          )
        ],

      ),
      // backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body:  loading ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primarycolor)))
          : listSCArr.isNotEmpty ? ListView.builder(
          itemCount: listSCArr.length,
          itemBuilder: (context, i) {
            final nDataList = listSCArr[i];
            String fName =  nDataList.onlineStatus;
            print(fName);
            return Dismissible(
                key: Key(nDataList.senderName),
                background: slideRightBackground(),
                secondaryBackground: slideLeftBackground(),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                                "Are you sure you want to unread ?"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  // TODO: Delete the item from DB etc..
                                  setState(() {
                                    action(nDataList.notificationId,"unread");
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                    return res;
                  } else {
                    // TODO: Navigate to edit page;
                  }

                  if (direction == DismissDirection.startToEnd) {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                                "Are you sure you want to unread ?"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  // TODO: Delete the item from DB etc..
                                  setState(() {
                                    action(nDataList.notificationId,"unread");
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                    return res;
                  } else {
                    // TODO: Navigate to edit page;
                  }
                  return null;
                },
                child: InkWell(
                    child:  Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 14.0, right: 14.0, top: 5.0, bottom: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(nDataList.senderImage)
                                    )
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    if (fName == 'online')
                                      const Positioned(
                                        right: 0.0,
                                        bottom: 0.0,
                                        child: Icon(
                                          Icons.fiber_manual_record,
                                          size: 15.0,
                                          color: primarycolor,
                                        ),
                                      ),

                                    if (fName == 'offline')
                                      const Positioned(
                                        right: 0.0,
                                        bottom: 0.0,
                                        child: Icon(
                                          Icons.fiber_manual_record,
                                          size: 15.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                )
                            ),


                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          nDataList.senderName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87,
                                              fontSize: 17.0),
                                        ),
                                        Text(
                                          nDataList.dateTime,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                              fontSize: 13.5),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width/1.4,
                                              child: Text(
                                                nDataList.message,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black54,
                                                    fontSize: 15.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ]
                    )
                )
            );

          }):Container(
        child: const Center(
          child:Text("No Notification Are Avaliable", style: TextStyle(
            color: primarycolor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),),
        ),
      ),

    );
    }
}