import 'package:flutter/material.dart';
import 'package:cowdiar/screen/home/home.dart';
import 'package:cowdiar/screen/inbox/inbox.dart';
import 'package:cowdiar/screen/notifications/notifications.dart';
import 'package:cowdiar/screen/others/other.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cowdiar/screen/search/search.dart';
import 'package:cowdiar/services/api.dart';

void main() async {
  runApp(const MyHomePage(0));
}

class MyHomePage extends StatefulWidget {
  final int? menulink; //if you have multiple values add here
  const MyHomePage(this.menulink, {super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum LoginStatus { notSignIn, signIn }

class _MyHomePageState extends State<MyHomePage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.setString("name", "");
      preferences.setString("email", "");
      preferences.setString("id", "");

      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  int? menuvalue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuvalue = widget.menulink;
  }

  @override
  Widget build(BuildContext context) {
    Widget? child;
    switch (menuvalue) {
      case 0:
        child = const Home();
        break;
      case 1:
        child = const Inboxpage();
        break;
      case 2:
        child = const search();
        break;
      case 3:
        child = const Notifications();
        break;
      case 4:
        child = const Others();
        break;
    }

    return Container(
        color: Colors.red,
        child: Scaffold(
          backgroundColor: Colors.blueGrey.shade200,
          body: SizedBox.expand(child: child),
          bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                  primaryColor: Colors.red,
                  textTheme: Theme.of(context)
                      .textTheme
                      .copyWith(bodySmall: const TextStyle(color: Colors.black))),
              child: BottomNavigationBar(
                onTap: (newIndex) => setState(() => menuvalue = newIndex),
                currentIndex: menuvalue!,
                type: BottomNavigationBarType.fixed,
                fixedColor: primarycolor,
                items: [
                  //N-Replaced by activeIcon
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/home.png',
                        width: 22, height: 22, fit: BoxFit.fill),
                    activeIcon: Image.asset('assets/icons/home.png',
                        width: 22,
                        height: 22,
                        color: iconcolor,
                        fit: BoxFit.fill),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/inbox.png',
                        width: 22, height: 22, fit: BoxFit.fill),
                    activeIcon: Image.asset('assets/icons/inbox.png',
                        width: 22,
                        height: 22,
                        color: iconcolor,
                        fit: BoxFit.fill),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/search.png',
                        width: 22, height: 22, fit: BoxFit.fill),
                    activeIcon: Image.asset('assets/icons/search.png',
                        width: 22,
                        height: 22,
                        color: iconcolor,
                        fit: BoxFit.fill),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/note.png',
                        width: 20, height: 20, fit: BoxFit.fill),
                    activeIcon: Image.asset('assets/icons/note.png',
                        width: 20,
                        height: 20,
                        color: iconcolor,
                        fit: BoxFit.fill),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/profile.png',
                        width: 22, height: 22, fit: BoxFit.fill),
                    activeIcon: Image.asset('assets/icons/profile.png',
                        width: 22,
                        height: 22,
                        color: iconcolor,
                        fit: BoxFit.fill),
                    label: "",
                  ),
                ],
              )),
        ));
  }
}
