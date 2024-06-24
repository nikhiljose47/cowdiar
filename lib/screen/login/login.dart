import 'dart:io' show Platform;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cowdiar/screen/inbox/Inbox.dart';
import 'package:cowdiar/screen/notifications/Notifications.dart';
import 'package:cowdiar/util/appinfo.dart';
import 'package:http/http.dart' as http;
import 'package:cowdiar/screen/mainscreen.dart';
import 'package:cowdiar/screen/register/register.dart';
import 'package:cowdiar/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cowdiar/screen/forgetpassword/forget.dart';

class Login extends StatefulWidget {
  final String? logintxt;

  const Login(this.logintxt, {super.key});
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  FirebaseMessaging? _firebaseMessaging;
  final _key = GlobalKey<FormState>();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String? username, email, userId, password;
  FocusNode passwordFocusNode = FocusNode();
  bool _secureText = true;
  FocusNode emailFocusNode = FocusNode();
  var firebastoken;
  TextEditingController? _controller;
  TextEditingController? _controller2;
  List<AppInfo> apiinforlist = [];
  var child;

  var loading = false;
  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging!.getToken().then((token) {
      firebastoken = token;
    });
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    setState(() {
      loading = true;
    });
    print("firebasetoken");
    print(firebastoken);
    if (Platform.isIOS) {
      var body;
      if (validateEmail()) {
        child = {
          "email": userId,
          "password": password,
          "device_type": 'ios',
          "device_token": firebastoken,
        };
      } else {
        child = {
          "username": userId,
          "password": password,
          "device_type": 'ios',
          "device_token": firebastoken,
        };
      }
      final response =
          await http.post(Uri.parse(baseurl + version + loginurl), body: body);

      final data = jsonDecode(response.body);
      String value = data['status'];
      String token = data['commonArr']['token'];
      String message = data['message'];
      if (value == '1') {
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(token);
        });
      } else {
        _controller = TextEditingController(text: userId);
        _controller2 = TextEditingController(text: password);

        setState(() {
          loading = false;
        });
      }
    } else {
      var body;
      var child;
      if (validateEmail()) {
        child = {
          "email": userId,
          "password": password,
          "device_type": 'android',
          "device_token": firebastoken,
        };
      } else {
        child = {
          "username": userId,
          "password": password,
          "device_type": 'android',
          "device_token": firebastoken,
        };
      }
      final response =
          await http.post(Uri.parse(baseurl + version + loginurl), body: body);

      final data = jsonDecode(response.body);
      String value = data['status'];

      String message = data['message'];
      if (value == '1') {
        String token = data['commonArr']['token'];
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(token);
        });
      } else {
        _controller = TextEditingController(text: userId);
        _controller2 = TextEditingController(text: password);
        setState(() {
          loading = false;
        });
      }
      showAlertDialog(context, value);
    }
  }

  bool validateEmail() {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(userId!);
    // if (!regex.hasMatch(email)) {
    //   loginToast("Incorrect Email");
    // }
  }

  showAlertDialog(BuildContext context, String value) {
    String? title;
    String? content;
    List<Widget>? actions;

    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    if (value == '1') {
      title = "Success!";
      content = "Welcome Back";
      actions = [];
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MyHomePage(0)));
      });
    } else {
      title = "Oops!";
      content = "Password or username is incorrect. Please try again!";
      actions = [okButton];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
        title: Text(title!), content: Text(content!), actions: actions);
      },
    );
  }

  savePref(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("token", token);
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  Future<Null> getData() async {
    final responseDataappinfo = await http.post(Uri.parse(baseurl + version + sitedetails),
        body: {'mobile_type': Platform.isAndroid ? 'android' : 'ios'});
    if (responseDataappinfo.statusCode == 200) {
      final dataapinfo = responseDataappinfo.body;
      var datalist = jsonDecode(dataapinfo)['content']['app_info'] as List;
      setState(() {
        for (Map i in datalist) {
          apiinforlist.add(AppInfo.fromMap(i as Map<String, dynamic>));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    firebaseCloudMessaging_Listeners();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ClipRect(
                    child: Align(
                        alignment: Alignment.center,
                        heightFactor: 0.5,
                        child: Transform.scale(
                            scale: 0.8,
                            child:
                                Image.asset('assets/logo/cowdiar_logo.png')))),
                const Text(
                  "Welcome back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 45,
                    width: 300,
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 6, 6, 6),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: const Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.apple_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Login with Apple",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 45,
                    width: 300,
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    decoration: const BoxDecoration(
                        color: Color(0xff5890FF),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: const Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.facebook_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Login with Facebook",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "- OR -",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Material(
                          elevation: 0.0,
                          child: TextFormField(
                            controller: _controller,
                            validator: (e) => e!.isEmpty
                                ? "Please enter username/email"
                                : null,
                            onSaved: (e) => userId = e!,
                            style: const TextStyle(
                              color: primarycolor,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),

                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: primarycolor),
                              ),
                              // contentPadding: EdgeInsets.all(18),
                              labelText: "username/email",
                              labelStyle: TextStyle(
                                  color: emailFocusNode.hasFocus
                                      ? Colors.black
                                      : primarycolor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Material(
                          elevation: 0.0,
                          child: TextFormField(
                            controller: _controller2,
                            validator: (e) =>
                                e!.isEmpty ? "Please enter the password" : null,
                            obscureText: _secureText,
                            onSaved: (e) => password = e!,
                            style: const TextStyle(
                              color: primarycolor,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),

                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: "password",
                              labelStyle: TextStyle(
                                  color: passwordFocusNode.hasFocus
                                      ? Colors.black
                                      : primarycolor),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phonelink_lock,
                                    color: primarycolor),
                              ),
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(
                                    _secureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: primarycolor),
                              ),

                              // contentPadding: EdgeInsets.all(18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      primarycolor)))
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: primarycolor),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      onPressed: () {
                                        check();
                                      },
                                    ),
                                  ))),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                          width: 300,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton(
                                child: const Text(
                                  "FORGOT PASSWORD ?",
                                  style: TextStyle(
                                      color: primarycolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const forgetpass()),
                                  );
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "Skip >>",
                                  style: TextStyle(
                                      color: primarycolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyHomePage(0)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Don't have an Account ? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                          TextButton(
                            child: const Text("Sign Up ",
                                style: TextStyle(
                                    color: primarycolor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15)),
                            onPressed: () {
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ));
        break;
      case LoginStatus.signIn:
        print(widget.logintxt);
        if (widget.logintxt == "loginfull") {
          return const MyHomePage(0);
        } else if (widget.logintxt == "inbox") {
          return const Inboxpage();
        } else if (widget.logintxt == "nottification") {
          return const Notifications();
        }
//        return ProfilePage(signOut);
        break;
    }
    return Container();
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
