import 'package:flutter/material.dart';
import 'package:cowdiar/screen/setting/pushNotification.dart';
import 'package:cowdiar/screen/setting/email.dart';

class notification extends StatefulWidget {
  const notification({super.key});

  @override
  _notificaitionState createState() => _notificaitionState();
}
class _notificaitionState extends State<notification>{
  final int _index=0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios, size: 28,color: Colors.black87 ),
        title: const Text('Notifications',style: TextStyle(color: Colors.black87),),
        centerTitle: true,
      ),
      body:Column(
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
              title: const Text('Push notifications',
                  style:TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PushNotification()),
                );
              },),),


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
              title: const Text('Email notifications',
                  style:TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              trailing :const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const email()),
                );
              },),
          ),
        ],
      ),

    );
  }
}

