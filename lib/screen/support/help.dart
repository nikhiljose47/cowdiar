import 'package:flutter/material.dart';
import 'package:cowdiar/screen/Support/buyer.dart';
import 'package:cowdiar/services/api.dart';

class help extends StatefulWidget{
  const help({super.key,this.title});
  final String? title;
  @override
  _helpState createState()=>_helpState();
}
class _helpState extends State<help>{
  int _index=0;
  @override
  Widget build(BuildContext context) {
    //
    singleCard(iconcode,icontitle){
      return Card(
        color: Colors.white,
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                IconData(iconcode,fontFamily: 'MaterialIcons',),color: primarycolor,size: 25.0,),
              Text(
                icontitle!,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,

                ),
              )
            ],
          ),
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Help & Support',style: TextStyle(color:Colors.black87),),
        leading: const Icon(Icons.arrow_back_ios, size: 28,color: Colors.black87 ),
        centerTitle: true,

      ),
      body:Container(
        child:Column(children: <Widget>[
          const TextField(
            decoration: InputDecoration(
                labelText: "  What are you looking for?",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(45.0)))),
          ),Expanded(
            child:GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(2),
              children: <Widget>[
                singleCard(59576,'        Getting              \t       Started '),
                singleCard(59576, '      Accounts &   \tProfile Settings '),
                singleCard(60223, '     Buying on         \t     Proposal'),
                singleCard(59576, '            My            \t        Orders'),
                singleCard(59553, '      Payment &        \t       Invoices'),
                singleCard(59641, '     Bussiness       \t        Tools'),
              ],
            ),),
          Container(
            child: const Padding(
                padding: EdgeInsets.only(top:10.0),
                child: Text("Can't find what you're looking for?",style: TextStyle(fontSize: 16.0,height: 1.5),textAlign: TextAlign.center,)
            ),
          ),
          Container(
            child: const Align(
              alignment: FractionalOffset.center,
              child: Text("Please visit our Help Center for more information",style: TextStyle(fontSize: 16.0,height: 1.5),textAlign: TextAlign.center,),
            ),
          ),
          Expanded(
            child:Align(
              alignment:FractionalOffset.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top:16.0),
                child: ElevatedButton(
                  onPressed: (){ Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>const buyer() ),
                  );
                  },
                  child: const Text("BUYER HELP CENTER"),
                ),
              ),
            ),
          ),
        ],
        ),
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