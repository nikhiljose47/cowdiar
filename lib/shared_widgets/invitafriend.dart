import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cowdiar/services/api.dart';
import 'package:cowdiar/util/appinfo.dart';
import 'package:share/share.dart';

class invitePage extends StatefulWidget {
  const invitePage({super.key});

  @override
  _invitePage createState() => _invitePage();
}

myBoxDecorationfirst() {
  return BoxDecoration(
      color: Colors.white,
      border: Border.all(
          color: Colors.grey,
          width: 0.5,
          style: BorderStyle.solid
      ),

      borderRadius:const BorderRadius.all(Radius.circular(10.0)
      ));
}

class _invitePage extends State<invitePage> {
  List<AppInfo> apiinforlist = [];
  String? linkdata;
  Uri? s;

  Future<Null> getData() async {
    //final responseDataappinfo = await http.post( Uri.parse(baseurl + version + sitedetails), body:{'mobile_type':Platform.isAndroid?'android':'ios'});
    final responseDataappinfo = await http.post(s!, body:{'mobile_type': Platform.isAndroid ?'android':'ios'});

    if (responseDataappinfo.statusCode == 200) {
      final dataapinfo = responseDataappinfo.body;
      var datalist = jsonDecode(dataapinfo)['content']['app_info']  as List;
      linkdata=jsonDecode(dataapinfo)['content']['app_info'][0]['app_link'];
      setState(() {
        for (Map i in datalist) {
          apiinforlist.add(AppInfo.fromMap(i as Map<String, dynamic>));
        }
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  @override
  Widget build(BuildContext context) {
    return linkdata != "" ?Container(
margin: const EdgeInsets.only(left: 5.0,right: 5.0),
      child: Center(
        child: Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(top:20,left: 10,right: 10,bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                apiinforlist.isNotEmpty ? Text("Invite friends & get up to ${apiinforlist[0].invitePrice}" ,style: const TextStyle(
                  fontSize: 16,
                  color: primarycolor,
                  fontWeight: FontWeight.w600,
                ),textAlign: TextAlign.center):const Text(""),
                const ListTile(
                  subtitle: Text('Introduce your friends to the fastest way to get things done.',textAlign: TextAlign.center,),
                ),
                ElevatedButton(
                  onPressed: ()
                    {
                      final RenderObject box = context.findRenderObject()!;
                      Share.share(linkdata!,
                          // sharePositionOrigin:
                          // box.localToGlobal(Offset.zero) &
                          // box.size
                          );
                    },
                  child: const Text(
                    "INVITE",
                    style: TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ):Container(height: 0,);
  }
}