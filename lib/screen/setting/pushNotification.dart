import 'package:cowdiar/services/api.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class PushNotification extends StatefulWidget{
  const PushNotification({super.key});

  @override
  _PushNotificationState createState(){
    return _PushNotificationState();
  }
}
class _PushNotificationState extends State<PushNotification> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  var inboxMessages;
  var orderMessages;
  var orderUpdates;
  var buyerRequests;
  var myProposals;
  var myAccounts;
  String token = "";
  @override
  void initState() {
    getData();
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
   // var iOS = new IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin!.initialize(initSetttings);
  }
  Future<Null> getData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!!;
    });
    final getdataresponse = await http.post(Uri.parse(baseurl + version + getnotifaction), headers: {
      'auth':token
    });
    var parsedJson = json.decode(getdataresponse.body);
    print(parsedJson);
    print("parsedJson");
    var status = parsedJson['status'];
    if(status == "1"){
      setState(() {
        inboxMessages = parsedJson['content']['notifications_setting']['inbox_push_notification_status'] == "1" ? true : false;
        print(inboxMessages);
        orderMessages = parsedJson['content']['notifications_setting']['order_message_push_notification_status'] == "1" ? true : false;
        print(orderMessages);
        orderUpdates = parsedJson['content']['notifications_setting']['order_update_push_notification_status'] == "1" ? true : false;
        print(orderUpdates);
        buyerRequests = parsedJson['content']['notifications_setting']['buyer_req_push_notification_status'] == "1" ? true : false;
        print(buyerRequests);
        myProposals = parsedJson['content']['notifications_setting']['myproposal_push_notification_status'] == "1" ? true : false;
        print(myProposals);
        myAccounts = parsedJson['content']['notifications_setting']['myaccount_push_notification_status'] == "1" ? true : false;
        print(myAccounts);
      });
    }
    else{

    }
  }
  Future<Null> updateData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!!;
    });
    final responseValue = await http.post(Uri.parse(baseurl + version + postnotifaction), body: {
      "inbox_push_notification_status": inboxMessages ? "1" : "0",
      "order_message_push_notification_status": orderMessages ? "1" : "0",
      "order_update_push_notification_status": orderUpdates ? "1" : "0",
      "buyer_req_push_notification_status": buyerRequests ? "1" : "0",
      "myproposal_push_notification_status": myProposals ? "1" : "0",
      "myaccount_push_notification_status": myAccounts ? "1" : "0",

    }, headers: {
      'auth':token
    });
    var parsedJson = json.decode(responseValue.body);
    print(parsedJson);
    print("parsedJson");
    var status = parsedJson['status'];
    if(status == "1"){
      print("Data Updated Successfully");
    }
  }

  Future<Null> updateEachData({String? key, bool? value}) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!!;
    });
    final responseValue = await http.post(Uri.parse(baseurl + version + postnotifaction), body: {
      key : value! ? "1" : "0",
    }, headers: {
      'auth': token
    });
    var parsedJson = json.decode(responseValue.body);
    print(parsedJson);
    print("parsedJson");
    var status = parsedJson['status'];
    if(status == "1"){
      print("Data Updated Successfully");
    }
  }


  Future<void> onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    return Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    print(inboxMessages);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text("Push Notifications",style: TextStyle(
          color: Colors.black,
        ),),
        centerTitle: true,
      ),
      body: inboxMessages == null && orderMessages == null && orderUpdates == null && buyerRequests == null && myProposals== null && myAccounts== null ?  Container(alignment: Alignment.center,child: const CircularProgressIndicator()) : Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child:ListTile(
              title: const Text(
                "Inbox Messages",
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
              trailing: FlutterSwitch(
                width: 36.0,
                height: 20.0,
                toggleSize: 15.0,
                inactiveColor: Colors.grey,
                activeColor: Colors.purple,
                toggleColor: Colors.white,
                value: inboxMessages,
                onToggle: (val) {
                  setState(() async {
                    inboxMessages = val;
                    print(inboxMessages);
                    updateEachData(key: "inbox_push_notification_status", value: inboxMessages);
                  });
                },
              ),
            ),),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child:ListTile(
              title: const Text(
                "Order Messages",
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
              trailing: FlutterSwitch(
                width: 36.0,
                height: 20.0,
                toggleSize: 15.0,
                inactiveColor: Colors.grey,
                activeColor: Colors.purple,
                toggleColor: Colors.white,
                value: orderMessages,
                onToggle: (val) {
                  setState(() {
                    orderMessages = val;
                    print(orderMessages);
                    updateEachData(key: "order_message_push_notification_status", value: orderMessages);
                  });
                },
              ),
            ),),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child:ListTile(
              title: const Text(
                "Order Updates",
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
              trailing: FlutterSwitch(
                width: 36.0,
                height: 20.0,
                toggleSize: 15.0,
                inactiveColor: Colors.grey,
                activeColor: Colors.purple,
                toggleColor: Colors.white,
                value: orderUpdates,
                onToggle: (val) {
                  setState(() {
                    orderUpdates = val;
                    print(orderUpdates);
                    updateEachData(key: "order_update_push_notification_status", value: orderUpdates);
                  });
                },
              ),
            ),),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child:ListTile(
              title: const Text(
                "Buyer Requestes",
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
              trailing: FlutterSwitch(
                width: 36.0,
                height: 20.0,
                toggleSize: 15.0,
                inactiveColor: Colors.grey,
                activeColor: Colors.purple,
                toggleColor: Colors.white,
                value: buyerRequests,
                onToggle: (val) {
                  setState(() {
                    buyerRequests = val;
                    print(buyerRequests);
                    updateEachData(key: "buyer_req_push_notification_status", value: buyerRequests);
                  });
                },
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child:ListTile(
              title: const Text(
                "My Propsals",
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
              trailing: FlutterSwitch(
                width: 36.0,
                height: 20.0,
                toggleSize: 15.0,
                inactiveColor: Colors.grey,
                activeColor: Colors.purple,
                toggleColor: Colors.white,
                value: myProposals,
                onToggle: (val) {
                  setState(() {
                    myProposals = val;
                    print(myProposals);
                    updateEachData(key: "myproposal_push_notification_status", value: myProposals);
                  });
                },
              ),
            ),),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child:ListTile(
              title: const Text(
                "My Accounts",
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
              trailing: FlutterSwitch(
                width: 36.0,
                height: 20.0,
                toggleSize: 15.0,
                inactiveColor: Colors.grey,
                activeColor: Colors.purple,
                toggleColor: Colors.white,
                value: myAccounts,
                onToggle: (val) {
                  setState(() {
                    myAccounts = val;
                    print(myAccounts);
                    updateEachData(key: "myaccount_push_notification_status", value: myAccounts);
                  });
                },
              ),
            ),
          ),
          inboxMessages == true ||  orderMessages == true || orderUpdates == true || buyerRequests == true || myProposals == true || myAccounts == true ? Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                onPressed: showNotification,
                child: const Text('TEST PUSH NOTIFICATION',style:TextStyle(fontSize: 15.0),),
              ),),):Container(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  showNotification() async {
    var android = const AndroidNotificationDetails(
        'channel id', 'channel NAME',
        priority: Priority.high,importance: Importance.max
    );
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin!.show(
        0, 'Push Test', 'Push Test Success', platform,
        payload: 'Push Test Success');
  }
}