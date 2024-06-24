import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cowdiar/util/appinfo.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cowdiar/screen/mainscreen.dart';
import 'package:cowdiar/screen/register/register.dart';
import 'package:cowdiar/services/api.dart';
import 'package:cowdiar/screen/login/login.dart';

class forgetpass extends StatefulWidget {
  const forgetpass({super.key});

  @override
  _forgetpassState createState() => _forgetpassState();
}

class _forgetpassState extends State<forgetpass> {
  final _key = GlobalKey<FormState>();
  String? email;
  FocusNode emailFocusNode = FocusNode();
  List<AppInfo> apiinforlist = [];
  bool shouldShowDialog = false;

  var loading = false;
  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      forgetpass();
    }
  }

  forgetpass() async {
    final response = await http
        .post(Uri.parse(baseurl + version + forgetpasslink), body: {"email": email});
    final data = jsonDecode(response.body);
    String value = data['status'];
    showAlertDialog(context, value);
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: secondercolor,
        textColor: Colors.white);
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

  bool validateEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
    // if (!regex.hasMatch(email)) {
    //   loginToast("Incorrect Email");
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  getData();
  }

  showAlertDialog(BuildContext context, String value) {
    String? title;
    String? content;
    if (value == '1') {
      title = "Success!";
      content =
          "An email has been sent to your email address with instructions on how to change your password.";
    } else {
      title = "Oops!";
      content = "We don't seem to have this email in our system.";
    }

    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MyHomePage(0)));
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title!),
      content: Text(content!),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            ClipRect(
                child: Align(
                    alignment: Alignment.center,
                    heightFactor: 0.7,
                    child: Image.asset('assets/logo/cowdiar_logo.png'))),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextFormField(
                      validator: (e) {
                        if (e!.isEmpty || !validateEmail(e)) {
                          return "Please enter email";
                        }
                        return null;
                      },
                      onSaved: (e) => email = e,
                      style: const TextStyle(
                        color: primarycolor,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: primarycolor),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: primarycolor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: primarycolor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(Icons.person, color: primarycolor),
                          ),
                          // contentPadding: EdgeInsets.all(18),
                          labelText: "Email",
                          labelStyle: TextStyle(
                              color: emailFocusNode.hasFocus
                                  ? Colors.black
                                  : primarycolor)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
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
                                "Reset Password",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18),
                              ),
                              onPressed: () {
                                check();
                              },
                            ),
                          ))),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: 280,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            child: const Text(
                              "<< Login",
                              style: TextStyle(
                                  color: primarycolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login("loginfull")),
                              );
                            },
                          ),
                          TextButton(
                            child: const Text(
                              "Skip >>",
                              style: TextStyle(
                                  color: primarycolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
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
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Don't have an Account ? ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                      TextButton(
                        child: const Text("Sign Up ",
                            style: TextStyle(
                                color: primarycolor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14)),
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
                  )
                ],
              ),
            )
          ],
        ));
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
