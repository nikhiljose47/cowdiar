import 'package:flutter/material.dart';
import 'package:cowdiar/screen/details/catdetail.dart';
import 'package:cowdiar/screen/inbox/inboxdetail.dart';
import 'package:cowdiar/screen/login/login.dart';
import 'package:cowdiar/screen/profiledetails/cart.dart';
import 'package:cowdiar/screen/profiledetails/contactus.dart';
import 'package:cowdiar/util/home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cowdiar/util/propusal.dart';
import 'package:cowdiar/services/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cowdiar/screen/custom_expansion_tile.dart' as custom;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cowdiar/screen/mainscreen.dart';

class profiledetailpage extends StatefulWidget {
  final String links,
      sublink,
      title,
      pretitle,
      prelink; //if you have multiple values add here
  const profiledetailpage(
      this.links, this.sublink, this.title, this.prelink, this.pretitle,
      {super.key});

  @override
  _profiledetailpageState createState() => _profiledetailpageState();
}

class _profiledetailpageState extends State<profiledetailpage> {
  List<PDetail> listdata = [];
  List<Faq> listfaq = [];
  List<Review> listreview = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String>? imageslist;
  VoidCallback? _showPersBottomSheetCallBack;
  bool isExpanded = false;
  var loading = false;
  String token = "";
  List<RView> listreviews = [];
  bool readmore = true;
  bool readless = false;
  var descriptionLength;

  myBoxDecorationfirst() {
    return BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.grey, width: 0.5, style: BorderStyle.solid),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)));
  }

  addcart(String package, String product, String quenty) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    setState(() {
      loading = true;
    });

    final response = await http.post(Uri.parse(baseurl + version + addcartpage), body: {
      "proposal_id": package,
      "package_id": product,
      "proposal_qty": quenty
    }, headers: {
      'Auth': token
    });
    print(baseurl + version + addcartpage);
print(response);
    print(package);
    print(product);
    print(quenty);
    print(token);

    final data = jsonDecode(response.body);
    print(data);
    String value = data['status'];
    print(value);
    String message = data['message'];
    if (value == '1') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const cart();
          },
        ),
      );
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

  Future<Null> reviewgetData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    setState(() {
      loading = true;
    });

    final responseData =
        await http.get(Uri.parse(baseurl + version + url), headers: {'Auth': token});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var recents = jsonDecode(data)['content']['rViews'] as List;
      setState(() {
        for (Map i in recents) {
          listreviews.add(RView.fromMap(i as Map<String, dynamic>));
        }

        loading = false;
      });
    }
    }

  Future<Null> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    setState(() {
      loading = true;
    });

    final linkdata = '/${widget.links}';
    final responseData = await http
        .get(Uri.parse(baseurl + version + linkdata), headers: {'Auth': token});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      print(baseurl + version + linkdata);
      print(token);
      print(data);
      var listsCArr = jsonDecode(data)['content']['pDetails'] as List;
      setState(() {
        for (Map i in listsCArr) {
          listdata.add(PDetail.fromMap(i as Map<String, dynamic>));
        }
        loading = false;
      });
    }
    }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reviewgetData();
    _showPersBottomSheetCallBack = _showBottomSheet;
    getData();
  }

  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });
    _scaffoldKey.currentState!
        .showBottomSheet((context) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: const Alignment(-1.0, -1.0),
                    padding: const EdgeInsets.only(
                        left: 10.00, right: 10.00, top: 10.00, bottom: 5.00),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(listdata[0]
                                                .seller!
                                                .sellerImage!))),
                                    child: Stack(
                                      children: <Widget>[
                                        if (listdata[0].seller!.onlineStatus! ==
                                            'online')
                                          const Positioned(
                                            right: 0.0,
                                            bottom: 0.0,
                                            child: Icon(
                                              Icons.fiber_manual_record,
                                              size: 15.0,
                                              color: primarycolor,
                                            ),
                                          ),
                                        if (listdata[0].seller!.onlineStatus ==
                                            'offline')
                                          const Positioned(
                                            right: 0.0,
                                            bottom: 0.0,
                                            child: Icon(
                                              Icons.fiber_manual_record,
                                              size: 15.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  padding: const EdgeInsets.only(left: 10.00),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                  padding:
                                                      const EdgeInsets.only(left: 0),
                                                  child: Text(
                                                    listdata![0]
                                                        .seller!
                                                        .sellerName!,
                                                    style: const TextStyle(),
                                                    textAlign: TextAlign.left,
                                                  )),
                                              Container(
                                                  width: 100.0,
                                                  padding:
                                                      const EdgeInsets.only(top: 5),
                                                  child: Row(
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.orange,
                                                        size: 16.0,
                                                      ),
                                                      Text(
                                                        listdata[0]
                                                            .rating!
                                                            .averageRatting!,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.orange,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        " (${listdata[0]
                                                                .rating!
                                                                .totalReviews})",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        width: MediaQuery.of(context).size.width,
                        child: const Text("User Information"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_circle,
                                color: Colors.grey,
                                size: 30.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10.00),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              padding: const EdgeInsets.only(left: 0),
                                              child: const Text(
                                                "Seller Level",
                                                style: TextStyle(),
                                                textAlign: TextAlign.left,
                                              )),
                                          Container(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    listdata[0]
                                                        .seller!
                                                        .sellerLevel!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 30.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10.00),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              padding: const EdgeInsets.only(left: 0),
                                              child: const Text(
                                                "Location",
                                                style: TextStyle(),
                                                textAlign: TextAlign.left,
                                              )),
                                          Container(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    listdata[0]
                                                        .seller!
                                                        .sellerCountry!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.folder_open,
                                color: Colors.grey,
                                size: 30.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10.00),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              padding: const EdgeInsets.only(left: 0),
                                              child: const Text(
                                                "Recent Delivery",
                                                style: TextStyle(),
                                                textAlign: TextAlign.left,
                                              )),
                                          Container(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    listdata[0]
                                                        .seller!
                                                        .recentDelivery!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.date_range,
                                color: Colors.grey,
                                size: 30.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10.00),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              padding: const EdgeInsets.only(left: 0),
                                              child: const Text(
                                                "Seller Since",
                                                style: TextStyle(),
                                                textAlign: TextAlign.left,
                                              )),
                                          Container(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    listdata[0]
                                                        .seller!
                                                        .sellerSince!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.grey,
                                size: 30.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10.00),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              padding: const EdgeInsets.only(left: 0),
                                              child: const Text(
                                                "Seller Last Activity",
                                                style: TextStyle(),
                                                textAlign: TextAlign.left,
                                              )),
                                          Container(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    listdata[0]
                                                        .seller!
                                                        .sellerLastActivity!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 1,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                left: 15.00,
                                right: 10.00,
                                top: 0.00,
                                bottom: 10.00),
                            child: const Text(
                              "Description",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                left: 15.00,
                                right: 10.00,
                                top: 0.00,
                                bottom: 10.00),
                            child:
                                listdata[0].seller!.sellerDescription!.length >=
                                        200
                                    ? Text(
                                        listdata[0]
                                            .seller!
                                            .sellerDescription!
                                            .substring(0, 200),
                                      )
                                    : Text(
                                        listdata[0].seller!.sellerDescription!,
                                      ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  Widget expendableList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listfaq.length.compareTo(0),
      itemBuilder: (context, i) {
        final datapass = listdata[i];
        return custom.ExpansionTile(
          headerBackgroundColor: Colors.white,
          iconColor: isExpanded ? primarycolor : Colors.black,
          title: Text(
            "Frequently Asked Questions",
            style: TextStyle(
              color: isExpanded ? primarycolor : Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(datapass.faqs![i].question!),
                  subtitle: Text(datapass.faqs![i].answer!),
                )
              ],
            ),
          ],
          onExpansionChanged: (bool expanding) =>
              setState(() => isExpanded = expanding),
        );
      },
    );
  }

  Widget reviewexpendableList() {
    return listdata[0].reviews!.length == 0
        ? Container()
        : custom.ExpansionTile(
            headerBackgroundColor: Colors.white,
            iconColor: isExpanded ? primarycolor : Colors.black,
            title: Text(
              "Reviews",
              style: TextStyle(
                color: isExpanded ? primarycolor : Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              Column(
                children: <Widget>[
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listdata[0].reviews!.length.compareTo(0),
                      itemBuilder: (context, index) {
                        final datapass = listdata[0].reviews![index];

                        return Container(
                          alignment: const Alignment(-1.0, -1.0),
                          padding: const EdgeInsets.only(
                              left: 10.00,
                              right: 10.00,
                              top: 10.00,
                              bottom: 5.00),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      datapass.buyerImage!)))),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        padding: const EdgeInsets.only(left: 10.00),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    padding: const EdgeInsets.only(
                                                        left: 0),
                                                    child: Text(
                                                      datapass.buyerName!,
                                                      style: const TextStyle(),
                                                      textAlign: TextAlign.left,
                                                    )),
                                                Row(
                                                  children: <Widget>[
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.orange,
                                                      size: 16.0,
                                                    ),
                                                    Container(
                                                      child: Text(
                                                          datapass.buyerRating!,
                                                          style: const TextStyle(
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                          textAlign:
                                                              TextAlign.right),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(left: 0),
                                                ),
                                                Container(
                                                  child: Text(
                                                      datapass.reviewDate!,
                                                      textAlign:
                                                          TextAlign.right),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 25.00),
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: Text(datapass.buyerReview!,
                                    textAlign: TextAlign.left),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ],
            onExpansionChanged: (bool expanding) =>
                setState(() => isExpanded = expanding),
          );
  }

  Widget review(context) {
    return Column(
      children: <Widget>[
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0, top: 0.00),
            child: Text('Recently Viewes & more',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'SophiaNubian',
                )),
          ),
        ]),
        Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 5, top: 5),
            // alignment: FractionalOffset(1.0, 1.0),
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(primarycolor)))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    primary: false,
                    itemCount: listreviews.length,
                    itemBuilder: (context, i) {
                      final nplacesList = listreviews[i];
                      return GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 5.00, top: 5.00, right: 5.00),
                          width: 250,
                          decoration: myBoxDecorationfirst(),
                          child: Column(children: <Widget>[
                            SizedBox(
                              height: 150,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    //height: 150,
                                    width: double.infinity,
                                    child: Image.network(
                                      nplacesList.postImage!,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 10.00,
                                  right: 10.00,
                                  top: 10.00,
                                  bottom: 5.00),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      nplacesList
                                                          .sellerImage!)))),
                                      Container(
                                        padding: const EdgeInsets.only(left: 5.00),
                                        child:
                                            Text(nplacesList.sellerName!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(right: 10.00, left: 10.00),
                              child: Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 5),
                                        child: Text(nplacesList.sellerLevel!),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  right: 10.00, left: 10.00, top: 10.00),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Row(children: <Widget>[
                                            const Text(
                                              "From ",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: primarycolor,
                                              ),
                                              maxLines: 2,
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              "${nplacesList.price}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: primarycolor,
                                              ),
                                              maxLines: 2,
                                              textAlign: TextAlign.left,
                                            ),
                                          ])),
                                    ],
                                  ),
                                  Row(children: <Widget>[
                                    Container(
                                        child: Row(children: <Widget>[
                                      const Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.orangeAccent,
                                      ),
                                      Text(
                                        "${nplacesList.rating!.averageRatting}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.orangeAccent,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        "(${nplacesList.rating!.totalReviews})",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black38,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                      ),
                                    ])),
                                  ]),
                                ],
                              ),
                            ),
                          ]),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return profiledetailpage(nplacesList.link!,
                                    "home", "home", "home", "home");
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          )
        ]),
      ],
    );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primarycolor)))
          : listdata.isNotEmpty
              ? ListView(
                  children: [
                    Column(
                      children: <Widget>[
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listdata.length.compareTo(0),
                          itemBuilder: (context, i) {
                            print("titleh");
                            // print(listdata[0].title.length < 30? listdata[0].title.length : listdata[0].title.substring(0, 30).length + listdata[0].description.length < 62? listdata[0].description.length: listdata[0].description.substring(0,62).length);
                            final datapass = listdata[i];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0.0, vertical: 0.0),
                                    color: Colors.white,
                                    height: 200,
                                    child: datapass.images!.length != 1
                                        ? CarouselSlider.builder(
                                            itemCount: datapass.images!.length,
                                            itemBuilder: (context, index, int) {
                                              return Container(
                                                  child: Image.network(
                                                datapass.images![index]!,
                                                fit: BoxFit.cover,
                                                width: 350,
                                                height: 260,
                                              ));
                                            },
                                            options: CarouselOptions(
                                              height: 400,
                                              //aspectRatio: 16/9,
                                              viewportFraction: 0.8,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval:
                                                  const Duration(seconds: 5),
                                              autoPlayAnimationDuration:
                                                  const Duration(milliseconds: 800),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: false,
                                              scrollDirection:
                                                  Axis.horizontal,
                                            ))
                                        : datapass.images!.length != null
                                            ? Container(
                                                child: Image.network(
                                                datapass.images![0],
                                                fit: BoxFit.fill,
                                                width: 350,
                                                height: 260,
                                              ))
                                            : Container(),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // BoxShape.circle or BoxShape.retangle
                                        color: primarycolor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: wavesecond!,
                                            blurRadius: 15.0,
                                          ),
                                        ]),
                                    // padding: EdgeInsets.only(left: 10),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 20.0),

                                    child: widget.sublink == "home"
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return const MyHomePage(0);
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        : widget.sublink == "search"
                                            ? IconButton(
                                                icon: const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return const MyHomePage(2);
                                                      },
                                                    ),
                                                  );
                                                },
                                              )
                                            : IconButton(
                                                icon: const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return catdetail(
                                                            widget.sublink,
                                                            widget.title,
                                                            widget.pretitle,
                                                            widget.prelink);
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                  ),
                                ]),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width / 1,
                                  alignment: const Alignment(-1.0, -1.0),
                                  padding: const EdgeInsets.only(
                                      left: 10.00,
                                      right: 10.00,
                                      top: 10.00,
                                      bottom: 5.00),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              width: 50.0,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          datapass.seller!
                                                              .sellerImage!))),
                                              child: Stack(
                                                children: <Widget>[
                                                  if (datapass.seller!
                                                      .onlineStatus! ==
                                                      'online')
                                                    const Positioned(
                                                      right: 0.0,
                                                      bottom: 0.0,
                                                      child: Icon(
                                                        Icons
                                                            .fiber_manual_record,
                                                        size: 15.0,
                                                        color: primarycolor,
                                                      ),
                                                    ),
                                                
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.keyboard_arrow_down),
                                        onPressed:
                                        _showPersBottomSheetCallBack,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: const Alignment(-1.0, -1.0),
                                  padding: const EdgeInsets.only(
                                      left: 10.00,
                                      right: 10.00,
                                      top: 10.00,
                                      bottom: 5.00),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(left: 10.00),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                padding:
                                                    const EdgeInsets.only(left: 0),
                                                child: datapass
                                                            .title!.length >=
                                                        30
                                                    ? Text(
                                                        "${datapass.title!
                                                                .substring(
                                                                    0, 30)}...",
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )
                                                    : Text(
                                                        datapass.title!,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.90,
                                              child: datapass.description!
                                                          .length >=
                                                      62
                                                  ? Wrap(
                                                      children: [
                                                        Text(readmore
                                                            ? '${datapass
                                                                    .description!
                                                                    .substring(
                                                                        0,
                                                                        62)}...'
                                                            : ''),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              readmore = false;
                                                              descriptionLength =
                                                                  datapass
                                                                      .description!
                                                                      .length;
                                                            });
                                                          },
                                                          child: Text(
                                                            readmore
                                                                ? 'Read More'
                                                                : datapass
                                                                    .description!,
                            style: TextStyle(
                                            color: readmore? Colors
                                                .red:Colors.black),
                                                            textAlign:
                                                                TextAlign
                                                                    .justify,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  // ? Text.rich(TextSpan(
                                                  //     text: readmore?datapass
                                                  //             .description
                                                  //             .substring(
                                                  //                 0, 62) +
                                                  //         '...':'',
                                                  //     children: <
                                                  //         TextSpan>[
                                                  //         TextSpan(
                                                  //             text: readmore
                                                  //                 ? 'Read More'
                                                  //                 : datapass
                                                  //                     .description,
                                                  //             style: TextStyle(
                                                  //                 color: readmore? Colors
                                                  //                     .red:Colors.black),
                                                  //             recognizer:
                                                  //                 new TapGestureRecognizer()
                                                  //                   ..onTap =
                                                  //                       () {
                                                  //               setState(() {
                                                  //                 descriptionLength = datapass.description.length;
                                                  //               });
                                                  //               print(datapass.description.length);
                                                  //               print('jj');
                                                  //                     setState(() {
                                                  //                       readmore = false;
                                                  //                     });
                                                  //                   }),
                                                  //       ]))
                                                  : Text(
                                                      datapass.description!,
                                                    ),
                                            ),
                                            readmore
                                                ? Container(
                                                    height: 0,
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      print('dbf');
                                                      setState(() {
                                                        readmore = true;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: const Text(
                                                        'Read Less',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        DefaultTabController(
                          length: 3,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 2.5,
                            child: Column(
                              children: <Widget>[
                                TabBar(
                                  labelColor: Colors.white,
                                  unselectedLabelColor: primarycolor,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      color: primarycolor),
                                  tabs: <Widget>[
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(listdata[0]
                                            .pPackages![0]
                                            .packageName
                                            .toString()),
                                      ),
                                    ),
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(listdata[0]
                                            .pPackages![1]
                                            .packageName
                                            .toString()),
                                      ),
                                    ),
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(listdata[0]
                                            .pPackages![2]
                                            .packageName
                                            .toString()),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    listdata[0]
                                                        .pPackages![0]
                                                        .packageName!,
                                                    textAlign: TextAlign.left,
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata![0]
                                                              .pPackages![0]
                                                              .description!
                                                              .length >
                                                          30
                                                      ? '${listdata[0]
                                                              .pPackages![0]
                                                              .description!
                                                              .substring(
                                                                  0, 30)}...'
                                                      : listdata[0]
                                                          .pPackages![0]
                                                          .description!)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  const Text("Revisions"),
                                                  Text(listdata[0]
                                                      .pPackages![0]
                                                      .revisions!)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  const Text("Delivery Time"),
                                                  Text(listdata[0]
                                                      .pPackages![0]
                                                      .deliveryTime!)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  const Text("price"),
                                                  Text(listdata[0]
                                                      .pPackages![0]
                                                      .price!)
                                                ],
                                              ),
                                            ),
                                            token == null
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: const EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: TextButton(
                                                      child: const Text('Log In '),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Login(
                                                                    "loginfull"),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: const EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: TextButton(
                                                      child: Text(
                                                          'Add To Cart ${listdata[0]
                                                                  .pPackages![0]
                                                                  .price}'),
                                                      onPressed: () {
                                                        setState(() {
                                                          addcart(
                                                              listdata[0]
                                                                  .proposalId!,
                                                              listdata[0]
                                                                  .pPackages![0]
                                                                  .packageId!,
                                                              "1");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                      .pPackages![1]
                                                      .packageName!)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                              .pPackages![1]
                                                              .description!
                                                              .length >
                                                          20
                                                      ? '${listdata[0]
                                                              .pPackages![1]
                                                              .description!
                                                              .substring(
                                                                  0, 21)}...'
                                                      : listdata[0]
                                                          .pPackages![1]
                                                          .description!)
                                                ],
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  const Text("Revisions"),
                                                  listdata[0]
                                                              .pPackages![1]
                                                              .revisions!
                                                              .length ==
                                                          0
                                                      ? const Text("--")
                                                      : Text(listdata[0]
                                                          .pPackages![1]
                                                          .revisions!)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  const Text("Delivery Time"),
                                                  Text(listdata[0]
                                                      .pPackages![1]
                                                      .deliveryTime!)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  const Text("price"),
                                                  Text(listdata[0]
                                                      .pPackages![1]
                                                      .price!)
                                                ],
                                              ),
                                            ),
                                            token == null
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: const EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: TextButton(
                                                      child: const Text('Log In '),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Login(
                                                                    "loginfull"),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: const EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: TextButton(
                                                      child: Text(
                                                          'Add To Cart ${listdata[0]
                                                                  .pPackages![1]
                                                                  .price}'),
                                                      onPressed: () {
                                                        setState(() {
                                                          addcart(
                                                              listdata[0]
                                                                  .proposalId!,
                                                              listdata[0]
                                                                  .pPackages![1]
                                                                  .packageId!,
                                                              "1");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .packageName!)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                              .pPackages![2]
                                                              .description!
                                                              .length >
                                                          38
                                                      ? '${listdata[0]
                                                              .pPackages![2]
                                                              .description!
                                                              .substring(
                                                                  0, 38)}...'
                                                      : listdata[0]
                                                          .pPackages![2]
                                                          .description!)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  const Text("Revisions"),
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .revisions!)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  const Text("Delivery Time"),
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .deliveryTime!)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  const Text("price"),
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .price!)
                                                ],
                                              ),
                                            ),
                                            token == null
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: const EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: TextButton(
                                                      child: const Text('Log In '),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Login(
                                                                    "loginfull"),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: const EdgeInsets.only(
                                                        top: 10,
                                                        right: 20,
                                                        left: 20),
                                                    child: TextButton(
                                                      child: Text(
                                                          'Add To Cart ${listdata[0]
                                                                  .pPackages![2]
                                                                  .price}'),
                                                      onPressed: () {
                                                        setState(() {
                                                          addcart(
                                                              listdata[0]
                                                                  .proposalId!,
                                                              listdata[0]
                                                                  .pPackages![2]
                                                                  .packageId!,
                                                              "1");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    primarycolor)))
                        : Container(
                            child: expendableList(),
                          ),
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    primarycolor)))
                        : Container(
                            child: reviewexpendableList(),
                          ),
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    primarycolor)))
                        : listdata[0].reviews!.length != 0
                            ? const SizedBox(
                                height: 20,
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                    review(context),
                  ],
                )
              : const Center(
                  child: Text(
                  "Loading..",
                  style: TextStyle(fontSize: 20, color: primarycolor),
                )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          listdata[0].seller!.messagegroupid!.toString().isNotEmpty
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Inboxdetailpage(listdata[0].seller!.messagegroupid!,
                          listdata[0].seller!.sellerName!);
                    },
                  ),
                )
              : listdata[0].seller!.messagegroupid.toString().isEmpty
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return contactdetailpage(listdata[0].seller!.sellerId!,
                              listdata[0].seller!.sellerName!);
                        },
                      ),
                    )
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login("loginfull"),
                      ),
                    );
        },
        label: loading
            ? const Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(primarycolor)))
            : listdata.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(0.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.only(right: 15),
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        listdata[0].seller!.sellerImage!))),
                            child: Stack(
                              children: <Widget>[
                                if (listdata[0].seller!.onlineStatus == 'online')
                                  const Positioned(
                                    right: 0.0,
                                    bottom: 0.0,
                                    child: Icon(
                                      Icons.fiber_manual_record,
                                      size: 15.0,
                                      color: primarycolor,
                                    ),
                                  ),
                                if (listdata[0].seller!.onlineStatus ==
                                    'offline')
                                  const Positioned(
                                    right: 0.0,
                                    bottom: 0.0,
                                    child: Icon(
                                      Icons.fiber_manual_record,
                                      size: 15.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            )),
                        Container(
                            padding: const EdgeInsets.only(left: 5),
                            child: const Text(
                              'Chat',
                              style: TextStyle(
                                color: primarycolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                      ],
                    ))
                : const Text("Log in"),
        backgroundColor: Colors.white,
      ),
    );
  }
}
