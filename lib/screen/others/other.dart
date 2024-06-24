import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cowdiar/screen/managarequest/managarequest.dart';
import 'package:cowdiar/screen/manage/manage.dart';
import 'package:cowdiar/screen/manage/selling_order.dart';
import 'package:cowdiar/screen/onlistatus/onlinestatus.dart';
import 'package:cowdiar/screen/postarequest/postarequest.dart';
import 'package:cowdiar/screen/setting/terms.dart';
import 'package:cowdiar/screen/support/support.dart';
import 'package:cowdiar/util/appinfo.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cowdiar/services/api.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cowdiar/util/profile.dart';
import '../setting/logout.dart';
import '../setting/pushNotification.dart';
import '../setting/setting.dart';

class Others extends StatefulWidget {
  const Others({super.key});

  @override
  _OthersState createState() => _OthersState();
}

class _OthersState extends State<Others> {
  String token = "";
  var loading = false;
  String? linkdata;
  bool exitApp = false;
  List<MProfile> listService = [];
  String? listservicesstus;
  List<AppInfo> apiinforlist = [];
  
  Future<Null> getDatalist() async {
    final responseDataappinfo = await http.post(Uri.parse(baseurl + version + sitedetails),
        body: {'mobile_type': Platform.isAndroid ? 'android' : 'ios'});
    if (responseDataappinfo.statusCode == 200) {
      final dataapinfo = responseDataappinfo.body;
      var datalist = jsonDecode(dataapinfo)['content']['app_info'] as List;
      linkdata = jsonDecode(dataapinfo)['content']['app_info'][0]['app_link'];
      setState(() {
        for (Map i in datalist) {
          apiinforlist.add(AppInfo.fromMap(i as Map<String, dynamic>));
        }
      });
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    print(token);
    setState(() {
      loading = true;
    });
    print(token);
    final responseData =
        await http.get(Uri.parse(baseurl + version + profile), headers: {'Auth': token});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listservices = jsonDecode(data)['content']['mProfile'] as List;

      print(listservices);
      setState(() {
        for (Map i in listservices) {
          listService.add(MProfile.fromMap(i as Map<String, dynamic>));
        }
        loading = false;
      });
    }
    }

  getstatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    print(token);

    final responseDatastatus = await http
        .get(Uri.parse(baseurl + version + statuscheck), headers: {'Auth': token});
    if (responseDatastatus.statusCode == 200) {
      final data = responseDatastatus.body;
      var listservicesstus =
          jsonDecode(data)['content']['seller_status'] as String;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => onlinestatus(listservicesstus),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getDatalist();
  }

  List<Widget> sharedSettings() {
    return [
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
          child: ListTile(
            leading: const Icon(
              Icons.language,
            ),
            title: const Text('Language'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
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
          child: ListTile(
            leading: const Icon(
              Icons.currency_exchange,
            ),
            title: const Text('Currency'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
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
          child: ListTile(
            leading: const Icon(
              Icons.policy,
            ),
            title: const Text('About'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
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
        child: ListTile(
          leading: const Icon(
            Icons.format_indent_decrease,
          ),
          title: const Text('Terms of services'),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const terms()),
            );
          },
        ),
      ),
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
          child: ListTile(
            leading: const Icon(
              Icons.business,
            ),
            title: const Text('Become a Seller'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
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
          child: ListTile(
            leading: const Icon(
              Icons.display_settings,
            ),
            title: const Text('Appearence'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ))
    ];
  }

  Widget othersec(context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                width: double.maxFinite,
                height: 180,
                decoration: const BoxDecoration(
                  color: primarycolor,
                ),
                padding: const EdgeInsets.all(20.0),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                primarycolor)))
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: listService.length,
                        itemBuilder: (context, i) {
                          final datacard = listService[i];
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: InkWell(
                                    child: const Icon(
                                      Icons.settings,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Setting(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  child: CircleAvatar(
                                    radius: 35.0,
                                    backgroundImage:
                                        NetworkImage(datacard.sellerImage!),
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Center(
                                  child: Text(
                                    datacard.sellerName!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ]);
                        })),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(top: 15, bottom: 16, left: 20),
          decoration: const BoxDecoration(
            color: Colors.white10,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: const Text(
            "Buying",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 113, 113, 113),
            ),
          ),
        ),
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
          child: ListTile(
            leading: const Icon(
              Icons.reorder,
            ),
            title: const Text('Manage Orders'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const manageorder(),
                ),
              );
            },
          ),
        ),
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
          child: ListTile(
            leading: const Icon(
              Icons.list,
            ),
            title: const Text('Manage Requests'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const manageeq(),
                ),
              );
            },
          ),
        ),
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
          child: listService.isEmpty
              ? const Text("")
              : ListTile(
                  leading: const Icon(
                    Icons.open_in_new,
                  ),
                  title: const Text('Post a Request '),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => postarequest(
                            listService[0].sellerVerificationStatus),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.only(top: 6, bottom: 16, left: 20),
          decoration: const BoxDecoration(
            color: Colors.white10,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: const Text(
            "Selling",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 113, 113, 113),
            ),
          ),
        ),
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
          child: ListTile(
            leading: const Icon(
              Icons.reorder,
            ),
            title: const Text('Manage Orders'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SellingOrder(),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.only(top: 6, bottom: 16, left: 20),
          decoration: const BoxDecoration(
            color: Colors.white10,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: const Text(
            "General",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 113, 113, 113),
            ),
          ),
        ),
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
          child: ListTile(
            leading: const Icon(
              Icons.notifications,
            ),
            title: const Text(
              'Push Notification',
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PushNotification()),
              );
            },
          ),
        ),
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
          child: ListTile(
            leading: const Icon(
              Icons.cached,
            ),
            title: const Text('Online Status'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              getstatus();
              print(listservicesstus);
            },
          ),
        ),
        linkdata != ""
            ? Container(
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.rotate_left,
                  ),
                  title: const Text('Invite Friends'),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(linkdata!,
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
                  },
                ),
              )
            : Container(
                height: 0,
              ),
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
          child: ListTile(
            leading: const Icon(
              Icons.call,
            ),
            title: const Text('Support'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const support(0)),
              );
            },
          ),
        ), ...sharedSettings(), Container(
          decoration: const BoxDecoration(
            color: Colors.white10,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: ListTile(
            title: const Text(
              'Logout',
            ),
            leading: const Icon(
              Icons.logout,
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const logout()),
              );
            },
          ),
        ),
      ]
        
        ,
    );
    }

  Future<bool> onWillPop() {
    setState(() {
      exitApp = !exitApp;
      Future.delayed(const Duration(seconds: 5), () {
        exitApp = !exitApp;
      });
    });
    if (exitApp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: const Text("Are you sure to exit!"),
        margin: const EdgeInsets.all(60),
      ));
    } else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
    return false as Future<bool>;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop, child: Scaffold(body: othersec(context)));
  }
}
