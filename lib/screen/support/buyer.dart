import 'package:flutter/material.dart';
import 'package:cowdiar/services/api.dart';

class buyer extends StatefulWidget{
  const buyer({super.key});

  @override
  _buyerState createState()=>_buyerState();
}
class _buyerState extends State<buyer>{
  int _index=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Help Center'),
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
          const SizedBox(height: 0),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.white,
                  width: 0,
                ),
              ),
            ),
            child: const ListTile(
              title: Text('Getting Started',style: TextStyle(fontSize:18.0,height: 2.0,color: Colors.black87),textAlign: (TextAlign.start),),
            ),),
          const ListTile(
            title: Text('Using Proposal',style: TextStyle(fontSize: 15.0,height: 0.0,color: Colors.grey,),textAlign: TextAlign.start,),
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
            child:const ListTile(
              title: Text('How Does Propsal Work?',
                  style:TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward_ios),
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
            child:const ListTile(
              title: Text('What is Propsal Pro?',
                  style:TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward_ios),
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
            child:const ListTile(
              title: Text('Registration',style: TextStyle(fontSize: 15.0,height: 3.0,color: Colors.grey),textAlign: TextAlign.start,),
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
            child:const ListTile(
              title: Text("How do I register and activate my account?",
                  style:TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward_ios),
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
            child:const ListTile(
              title: Text('Where is my activation email?',
                  style:TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward_ios),
            ),), Container(
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
            child: const ListTile(
              title: Text('Receiving Invoices',style: TextStyle(fontSize: 15.0,height: 3.0,color: Colors.grey),textAlign: TextAlign.start,),
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
            child:const ListTile(
              title: Text('How Do I set up my billing information?',
                  style:TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward_ios),
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
            child:const ListTile(
              title: Text('I setup my billing? information; how do i receive an invoice?',
                  style:TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward_ios),
            ),),
        ],),
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