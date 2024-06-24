import 'package:flutter/material.dart';
import 'package:cowdiar/services/api.dart';

class email extends StatefulWidget{
  const email({super.key});

  @override
  _emailState createState(){
    return _emailState();
  }

}
class _emailState extends State<email> {
  int _index=0;
  bool _isSwitched = false;
  bool _newisSwitched=false;
  bool _onSwitched=false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios, size: 28,color: Colors.black87 ),
        title: const Text('Email Notification',style: TextStyle(color: Colors.black87),),
        centerTitle: true,
      ),
      body: Column(
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
              title:   const Text(
                "Order Messages",
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
              trailing: Switch(
                activeColor: primarycolor,
                onChanged: (bool newval) => setState(() => _isSwitched = newval),
                value: _isSwitched,
              ),),
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
              title: const Text('Order Updates', style: TextStyle(fontSize: 18,color: Colors.black),),
              trailing: Switch(
                activeColor: primarycolor,
                onChanged: (bool newval) => setState(() => _newisSwitched = newval),
                value: _newisSwitched,
              ),),
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
            child: ListTile(
              title: const Text('Inbox Messages', style: TextStyle(fontSize: 18,color: Colors.black),),
              trailing: Switch(
                activeColor: primarycolor,
                onChanged: (bool newval) => setState(() => _onSwitched = newval),
                value: _onSwitched,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex) => setState(() => _index = newIndex),
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        fixedColor: primarycolor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), activeIcon: Text("Home",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), activeIcon: Text("Inbox",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.search), activeIcon: Text("Explore",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), activeIcon: Text("Notifications",style: TextStyle(color: Colors.black87),)),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), activeIcon: Text("Others",style: TextStyle(color: Colors.black87),)),
        ],
      ),

    );
  }
}