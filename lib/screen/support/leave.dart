import 'package:flutter/material.dart';
import 'package:cowdiar/services/api.dart';

class leave extends StatefulWidget{
  const leave({super.key});

  @override
  _leaveState createState()=>_leaveState();
}
class _leaveState extends State<leave>{
  int _index=0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios, size: 28,color: Colors.black87 ,),
        title: const Text('Leave Feedback',style: TextStyle(color:Colors.black87),),
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
            child: ListTile(
              title: const Text('Happy',
                  style:TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: (){},
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
            child: ListTile(
              title: const Text('Confused',
                  style:TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  )),
              trailing :const Icon(Icons.arrow_forward_ios),
              onTap: (){},
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
              title: const Text('Unhappy',
                  style:TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: (){},
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
                    //N-title:Text()
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

