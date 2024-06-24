import 'package:flutter/material.dart';
import 'package:cowdiar/util/deliver.dart';
import 'package:cowdiar/util/dropcat.dart';
import 'package:cowdiar/util/dropsubcat.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cowdiar/services/api.dart';

class postarequest extends StatefulWidget {
  final int? sellerVerificationStatus;//if you have multiple values add here
  const postarequest(this.sellerVerificationStatus,{super.key});

  @override
  _postarequestState createState() => _postarequestState();
}

class _postarequestState extends State<postarequest> {
  String? dropdownValue;
  List<CArr> listService = [];
  List<DeliveryArr> datarime = [];
  String token = "";
  List<SCArr> listsubcat = [];
  var loading = false;
  String _mySelection, _mySelection2,_mySelectiondata,datacurrenct;
  String? newVal;
  final _key = GlobalKey<FormState>();
  String? selectedCountry;
  FocusNode titlenode = FocusNode();
  FocusNode descriptionnode = FocusNode();
  FocusNode delivertimenode = FocusNode();
  FocusNode budgetnode = FocusNode();
  String title,description,delivertime,budget;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
    setState(() {
      loading = true;
    });
  }
  save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print(token);
    print(_mySelection);
    print(_mySelection2);
    print(title);
    print(description);
    print(_mySelectiondata);
    print(dropdownValue);
    print(datacurrenct);
    final response = await http
        .post(Uri.parse(baseurl+version+postrequest), body: {
      "cat_id": _mySelection,
      "child_id": _mySelection2,
      "request_title": title,
      "request_description": description,
      "delivery_time": _mySelectiondata,
      "request_budget":datacurrenct + budget,
    } , headers: {'Auth': token});

    final data = response.body;
    var value = jsonDecode(data)['status'];
    var message = jsonDecode(data)['message'];
    var responseCode = jsonDecode(data)['response_code'];
    print(data);
    if(value == '1'){
      setState(() {
        loading = false;
        _mySelection = null;
        _mySelectiondata = null;
        _mySelection2 = null;
      });
      postreToast(message);
    }else{
      setState(() {
        loading = false;
      });
      postreToast(message);
    }
  }

  postreToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: primarycolor,
        textColor: Colors.white);
  }
  Future<Null> getData() async {
    setState(() {
      loading = true;
    });

    final responseData = await http.get(Uri.parse(baseurl+version+categorylink)
        );
    print("file");
    print(_mySelection);
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listservices = jsonDecode(data)['content']['cArr'] as List;

      setState(() {
        for (Map i in listservices) {
          listService.add(CArr.fromMap(i as Map<String, dynamic>));
        }
        loading = false;
      });
    }


  }
  Future<Null> getDatadate() async {
      final responseDatas = await http.get(Uri.parse(baseurl + version + deliverapidate)
           );
      final datas = responseDatas.body;
      var datedeli = jsonDecode(datas)['content']['deliveryArr'] as List;
      datacurrenct = jsonDecode(datas)['content']['currencyArr'][0]['symbol'];
      setState(() {
        for (Map i in datedeli) {
          datarime.add(DeliveryArr.fromMap(i as Map<String, dynamic>));
        }

      });
  }
  Future<Null> getDatas() async {
    listsubcat.clear();
    final responseDatas = await http.get(Uri.parse(baseurl+version+subcatlink + _mySelection)
         );
    final datas = responseDatas.body;
    var subcat = jsonDecode(datas)['content']['sCArr'] as List;
    print(subcat);
    setState(() {
      for (Map i in subcat) {
        listsubcat.add(SCArr.fromMap(i as Map<String, dynamic>));
      }
    });
    }

  //Panggil Data / Call Data
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getDatas();
    getDatadate();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Request', style: TextStyle(color: Colors.black87),),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primarycolor)))
          : widget.sellerVerificationStatus == 0 ? const Center(child: Text("Please confirm your email to use this feature.",style: TextStyle(color: primarycolor,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),textAlign: TextAlign.center,)): ListView(
          children: <Widget>[
            Form(
                key: _key,
                child: Container(
                  color: primarycolor[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(


                              border: Border(
                                bottom: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                top: BorderSide(
                                  color: primarycolor[100],
                                  width: 1.0,
                                ),
                              ),),
                            child: const ListTile(
                              title: Text('Add Title',
                                  style: TextStyle(height: 3.0, color: Colors
                                      .black, fontSize: 18.0),
                                  textAlign: (TextAlign.left)),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Padding(

                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Material(
                                elevation: 0.0,
                                child: TextFormField(
                                  maxLength: 200,
                                  maxLines: 1,

                                  focusNode: titlenode,
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      Text txt = const Text("Please Enter Description",
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.ltr);
                                      var fullname = txt.data;
                                      return? fullname;
                                    }
                                    return null;
                                  },
                                  onSaved: (e) => title = e,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  decoration: const InputDecoration(
                                      counterText: "",
                                      //contentPadding: EdgeInsets.all(15),
                                      labelText: "Enter Title",
                                      alignLabelWithHint: true,
                                      labelStyle: TextStyle(

                                          color: Colors.black
                                      )
                                  ),

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(


                              border: Border(
                                bottom: BorderSide(
                                  color: primarycolor[100],
                                  width: 1.0,
                                ),
                                top: BorderSide(
                                  color: primarycolor[100],
                                  width: 1.0,
                                ),
                              ),),
                            child: const ListTile(
                              title: Text('Add Description',
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 18.0),
                                  textAlign: (TextAlign.left)),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Material(
                                elevation: 0.0,
                                child: TextFormField(
                                  maxLength: 360,
                                  maxLines: 5,

                                  focusNode: descriptionnode,
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      Text txt = const Text("Please Enter Description",
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.ltr);
                                      var fullname = txt.data;
                                      return fullname;
                                    }
                                    return null;
                                  },
                                  onSaved: (e) => description = e,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  decoration: const InputDecoration(
                                      counterText: "",
                                      //contentPadding: EdgeInsets.all(15),
                                      labelText: "300 chart max",
                                      alignLabelWithHint: true,
                                      labelStyle: TextStyle(

                                          color: Colors.black
                                      )
                                  ),

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(


                              border: Border(
                                bottom: BorderSide(
                                  color: primarycolor[100],
                                  width: 1.0,
                                ),
                                top: BorderSide(
                                  color: primarycolor[100],
                                  width: 1.0,
                                ),
                              ),),
                            child: const ListTile(
                              title: Text('Choose a Category',
                                  style: TextStyle( color: Colors
                                      .black, fontSize: 18.0),
                                  textAlign: (TextAlign.left)),
                            ),
                          ),
                          Container(

                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton(

                                isExpanded: true,
                                hint:  const Text("Choose a Category"),
                                items: listService.map((item) {
                                  return DropdownMenuItem(

                                    value: item.catId.toString(),

                                    child: Text(item.title),

                                  );
                                }).toList(),
                                onChanged: (newVal) {

                                  setState(() {

                                    _mySelection = newVal;
                                  });
                                  getDatas();
                                },
                                value: _mySelection,
                              ),
                            ),
                          ),

                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: _mySelection == null ? Container() :
                              DropdownButton(
                                isExpanded: true,
                                hint:  const Text("Choose a Subcategory"),

                                items: listsubcat.map((item) {
                                  return DropdownMenuItem(
                                    value: item.childId,
                                    child: Text(item.title),


                                  );
                                }).toList(),
                                onChanged: (newVals) {

                                  setState(() {
                                    _mySelection2 = newVals;
                                  });
                                },
                                value: _mySelection2,
                              ),
                            ),
                          ),

                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(


                              border: Border(
                                bottom: BorderSide(
                                  color: primarycolor[100],
                                  width: 1.0,
                                ),
                                top: BorderSide(
                                  color: primarycolor[100],
                                  width: 1.0,
                                ),
                              ),),
                            child: const ListTile(
                              title: Text('Prefer service delivery time',
                                  style: TextStyle( color: Colors
                                      .black, fontSize: 18.0),
                                  textAlign: (TextAlign.left)),
                            ),
                          ),
                        ],
                      ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(

                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: DropdownButton(

                                    isExpanded: true,
                                    hint:  const Text("Choose a delivery time"),
                                    items: datarime.map((item) {
                                      return DropdownMenuItem(

                                        value: item.deliveryProposalTitle,

                                        child: Text(item.deliveryProposalTitle),

                                      );
                                    }).toList(),
                                    onChanged: (datavalue) {
                                      setState(() {
                                        _mySelectiondata = datavalue;
                                      });
                                    },
                                    value: _mySelectiondata,
                                  ),
                                ),
                              ),],
                          ),


                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(


                              border: Border(
                                bottom: BorderSide(
                                  color: primarycolor[100],
                                  width: 1.0,
                                ),
                                top: BorderSide(
                                  color: primarycolor[100],
                                  width: 1.0,
                                ),
                              ),),
                            child: const ListTile(
                              title: Text('What is your budget ?(optional)',
                                  style: TextStyle( color: Colors
                                      .black, fontSize: 18.0),
                                  textAlign: (TextAlign.left)),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Material(
                                elevation: 0.0,
                                child:    Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                           bottom: BorderSide(width: 1.0, color: Colors.grey),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width/15,
                                      padding: const EdgeInsets.only(top: 29,bottom: 12),
                                      child:Text(datacurrenct ,style: const TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w300,
    ),),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width/1.3,
                                       child:TextFormField(
                                      maxLength: 200,
                                      maxLines: 1,
                                      focusNode: budgetnode,
                                      validator: (e) {
                                        if (e.isEmpty) {
                                          Text txt = const Text("Please Enter budget",
                                              textAlign: TextAlign.center,
                                              textDirection: TextDirection.ltr);
                                          var fullname = txt.data;
                                          return fullname;
                                        }
                                        return null;
                                      },
                                      onSaved: (e) => budget = e,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      decoration: const InputDecoration(
                                          counterText: "",
                                          //contentPadding: EdgeInsets.all(15),
                                          labelText: "Budget(Min \$5)",
                                          alignLabelWithHint: true,
                                          labelStyle: TextStyle(

                                              color: Colors.black
                                          )
                                      ),
                                    ),
                                    ),
                                ]
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Container(
                              margin: const EdgeInsets.only(top:10.0, bottom: 20),

                              decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              color: primarycolor),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextButton(

                                  child: const Text(
                                    "SUBMIT YOUR REQUEST",
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
                    ],
                  ),
                )
            )

          ]
      ),
    );
  }
}
