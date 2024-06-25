import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cowdiar/screen/mainscreen.dart';
import 'package:cowdiar/screen/profiledetails/checkout.dart';
import 'package:cowdiar/services/api.dart';
import 'package:cowdiar/util/cartpage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  cartPage createState() => cartPage();
}

class cartPage extends State<cart> {
  int _itemCount = 0;
  List<CartDetail> datacart = [];
  List<Payment> directcontent = [];
  var loading = false;
  String token = "";

  addquenty(String productid, String count) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    print("index");
    print(count);
    print(token);
    print(productid);
    final response = await http.post(Uri.parse(baseurl + version + changecart),
        body: {"proposal_id": productid, "proposal_qty": count},
        headers: {'Auth': token});

    final data = jsonDecode(response.body);
    String value = data['status'];
    String message = data['message'];
    if (value == '1') {
      _itemCount = 0;
      loginToast(message);
      datacart.clear();
      directcontent.clear();
      getData();
    } else {
      setState(() {
        loading = false;
      });
      loginToast(message);
    }
  }

  delete(String productid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    print("index");
    print(token);
    print(productid);
    final response = await http.post(Uri.parse(baseurl + version + removecart),
        body: {"proposal_id": productid}, headers: {'Auth': token});

    final data = jsonDecode(response.body);
    String value = data['status'];
    String message = data['message'];
    if (value == '1') {
      loginToast(message);
      datacart.clear();
      directcontent.clear();
      getData();
    } else {
      setState(() {
        loading = false;
      });
      loginToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: primarycolor,
        textColor: Colors.white);
  }

  Future<Null> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    print("index");
    print(token);
    setState(() {
      loading = true;
    });

    final responseData = await http
        .get(Uri.parse(baseurl + version + cartpagelink), headers: {'Auth': token});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listsCArr = jsonDecode(data)['content']['cartDetails'] as List;
      var listsCArrs = jsonDecode(data)['content']['payments'] as List;
      print(listsCArr);
      setState(() {
        for (Map i in listsCArr) {
          datacart.add(CartDetail.fromMap(i as Map<String, dynamic>));
        }
        for (Map i in listsCArrs) {
          directcontent.add(Payment.fromMap(i as Map<String, dynamic>));
        }
        loading = false;
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
        appBar:  AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () =>  Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => const MyHomePage(0))),
          ),
          elevation: 0.0,
        title: SizedBox(
        width: MediaQuery.of(context).size.width/1.8,
  child: const Center(child:Text("Cart")
  )
  ),
        ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                itemCount: datacart.length,
                itemBuilder: (BuildContext context, int index) {
                  final datavalue = datacart[index];
                  return loading
                      ? const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(primarycolor)))
                      : Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            right: 30.0, bottom: 10.0),
                        child: Material(
                          borderRadius:
                          BorderRadius.circular(5.0),
                          elevation: 3.0,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height: 80,
                                  child: Image.network(
                                      datacart[index]
                                          .proposalImage!),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        datacart[index]
                                            .proposalTitle!,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        datacart[index].price!,
                                        style: const TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          datacart[index]
                                              .proposalQuantity == "2"
                                              ? IconButton(
                                            icon: const Icon(Icons.remove,color: primarycolor,),
                                            onPressed: () => setState(() {
                                             String value = (int.parse(datacart[index].proposalQuantity!)-1).toString();
                                                addquenty(datacart[index]
                                                    .proposalId!,
                                                    value);}),)
                                              : Container(),
                                          Text(datacart[index]
                                              .proposalQuantity! ,
                                            style: const TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 18.0)),
                                          IconButton(
                                              icon: const Icon(Icons.add,color: primarycolor),
                                              onPressed: () =>
                                                  setState(() {
                                                    String value = (int.parse(datacart[index].proposalQuantity!)+1).toString();
                                                    addquenty(datacart[index].proposalId!, value
                                                    );
                                                  }))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 15,
                        child: Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5.0)),
                            padding: const EdgeInsets.all(0.0),
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              print(datavalue.proposalId);
                              setState(() {
                                delete(datavalue.proposalId!);
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            loading
                ? const Center(
                child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(primarycolor)))
                : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      Text(
                        "Sub Total Price",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 16.0),
                      ),
                      directcontent.isNotEmpty? Text(
                        directcontent[0].subTotalPrice!,
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 16.0),
                      ):const Text(''),
                    ],),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      Text(
                        "Processing Fee  ",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 16.0),
                      ),
                      directcontent.isNotEmpty?  Text(
                        directcontent[0].processingFee!,
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 16.0),
                      ):const Text(''),
                    ],),

                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Total Price",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 16.0),
                      ),
                      directcontent.isNotEmpty?  Text(
                        directcontent[0].totalPrice!,
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 16.0),
                      ):const Text(''),
                    ],),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                          height: 50.0,
                          color: primarycolor,
                          child: Text(
                            "Checkout".toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => checkout( directcontent[0].paymentUrl!, token)),
                            );
                          }))
                ],
              ),
            )
          ],
        ),
      ),
    );
    }
}
