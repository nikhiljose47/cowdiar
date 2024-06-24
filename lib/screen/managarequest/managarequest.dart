import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cowdiar/util/managreq.dart';
import 'package:cowdiar/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class manageeq extends StatefulWidget {
  const manageeq({super.key});

  @override
  _manageeqState createState() => _manageeqState();
}

class _manageeqState extends State<manageeq> {
  int _selectedIndex = 0;
  String token = "";
  List<StatusArr> listSCArr = [];
  List<MRequestsArr> listvalues = [];
  List<MRequestsArr> listdeafultval = [];
  String? items;
  var loading = false;
  var loading2= false;
  Future<Null> getListViewItems(String items) async{
    listvalues.clear();
    setState(() {
      loading2 = true;
    });
  final responseData = await http.post(Uri.parse(baseurl + version + manrequestlink),
      body: {"status": items},
      headers: {'Auth': token});
  if (responseData.statusCode == 200) {
    final data = responseData.body;
    var listvalue = jsonDecode(data)['content']['mRequestsArr'] as List;
    print(listvalue);
    setState(() {
      for (Map i in listvalue) {
        listvalues.add(MRequestsArr.fromMap(i as Map<String, dynamic>));
      }
      loading2 = false;
    });
  }
    listdeafultval.clear();
  }
  Future<Null> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    print(token);
    setState(() {
      loading = true;
    });
    print(baseurl + version  + manage);
    final responseData = await http.post(Uri.parse(baseurl + version  + manrequestlink),
        headers: {'Auth': token}
        );
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listsCArr = jsonDecode(data)['content']['statusArr'] as List;
      var listdeafult = jsonDecode(data)['content']['mRequestsArr'] as List;
print(listdeafult);
      setState(() {
        for (Map i in listsCArr) {
          listSCArr.add(StatusArr.fromMap(i as Map<String, dynamic>));
        }
        for (Map i in listdeafult) {
          listdeafultval.add(MRequestsArr.fromMap(i as Map<String, dynamic>));
        }

        loading2 = false;
        loading = false;
      });

    }

  }
  active(String requestId, String valuest) async {
    listvalues.clear();
    print(requestId);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token")!;
    });
    print(baseurl + version  + manage);
    final responseData = await http.post(Uri.parse(baseurl + version  + requestlink),
        body: {
          'request_id': requestId,
          'request_status': valuest,
        },
        headers: {'Auth': token}
    );
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var value = jsonDecode(data)['status'];
      var message = jsonDecode(data)['message'];

      print(data);
      if(value == '1'){

        postreToast(message);

      }else{
        postreToast(message);
      }
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getListViewItems(items!);
  }

  _onSelected(int index) {

    setState(() => _selectedIndex = index
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title:
            const Text("Manage Request"),
        centerTitle: true,

      ),
      body: ListView(
        children: <Widget>[
          Column(
              children: <Widget>[ Container(
                height: 50,
                padding: const EdgeInsets.only(bottom: 10, top: 1.00),
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  itemCount: listSCArr.length,
                  itemBuilder: (context, i) {
                    final nDataList = listSCArr[i];
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedIndex == i
                                  ? primarycolor
                                  : Colors.white,
                              width: 3,
                            ),
                          ),
                        ),
                        // alignment: Alignment(-1.0, -1.0),
                        margin: const EdgeInsets.only(top: 0, left: 5, bottom: 5),
                        padding: const EdgeInsets.only(top: 0, left: 5, bottom: 5),
                        child: Center(
                          child: Container(

                            width: 125,
                            height: 80,
                            alignment: const Alignment(0.0, 1.0),
                            child: Text(
                              "${nDataList.requestStatus!.substring(0,1).toUpperCase()}${nDataList.requestStatus!.substring(1)} (${nDataList.count})",
                              style: TextStyle(
                                color: _selectedIndex == i
                                    ? primarycolor
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                //transform: TextTransform.capitalize,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        getListViewItems(nDataList.requestStatus!);

                        _onSelected(i);
                      },
                    );
                  },
                ),
              ),
              ]),
          SingleChildScrollView(
              child:  loading2
                  ? Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 70, top: 8.00),
          //alignment: FractionalOffset(1.0, 1.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/1.1,
    child: const Center( child: CircularProgressIndicator())
              ):
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(bottom: 70, top: 8.00),
                    //alignment: FractionalOffset(1.0, 1.0),
                    width: MediaQuery.of(context).size.width,
                    height: listvalues.isEmpty && listdeafultval.isEmpty ? 1:MediaQuery.of(context).size.height/1.1,
                    child:  listvalues.isEmpty ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: listdeafultval.length,
                        itemBuilder: (context, i) {
                          final datacard2 = listdeafultval[i];
                          return Container(
                              padding: const EdgeInsets.only(bottom: 20),

                              margin:  const EdgeInsets.only(left: 10, right: 10,bottom: 8),
                              child: GestureDetector(
                                child: Card(
                                  elevation: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: MediaQuery.of(context).size.width/2.5,
                                                          margin:  const EdgeInsets.only(left: 10, top: 8.00,bottom: 8),
                                                          child: Text(datacard2.requestDate!)),
                                                      Container(

                                                          width: MediaQuery.of(context).size.width/3,
                                                          margin:  const EdgeInsets.only(left: 10, top: 8.00,bottom: 8),
                                                          child: Container( color: primarycolor[500],
                                                              padding: const EdgeInsets.all(3),
                                                              child: Text(datacard2.requestStatus!.toUpperCase(),style: const TextStyle(
                                                                color: Colors.white,

                                                                fontSize: 14,
                                                              ),textAlign: TextAlign.center,))),
                                                      Container(
                                                          width: MediaQuery.of(context).size.width/10,
                                                          margin:  const EdgeInsets.only(left: 10, top: 8.00,bottom: 8),
                                                          child: IconButton(
                                                            icon: const Icon(Icons.clear),
                                                            color: Colors.grey,
                                                            onPressed: () {
                                                              active(datacard2.requestId!,"delete");

                                                              getListViewItems("active");
                                                            },
                                                          )),

                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                    Container(
                                                      padding: const EdgeInsets.all(8),
                                                      color: Colors.grey[200],
                                                        margin:  const EdgeInsets.only(bottom: 8),
                                                        width: MediaQuery.of(context).size.width/1.2,
                                                        child: Text(datacard2.requestDescription!)),
                                                    ],
                                                  ),
                                                  datacard2.deliveryDuration != null  ? Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:  const EdgeInsets.only(bottom: 8),
                                                          width: MediaQuery.of(context).size.width/1.2,
                                                          child:  Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: <Widget>[
                                                               const Icon(
                                                                  Icons.access_time,
                                                                ),
                                                                const Text("Duration ",style: TextStyle(
                                                                  color: Colors.black,

                                                                  fontSize: 16,
                                                                ),),
                                                                Text(datacard2.deliveryDuration!,style: const TextStyle(
                                                                  color: Colors.black,

                                                                  fontSize: 16,
                                                                ),),
                                                    ])),
                                                    ],
                                                  ):const Text(""),

                                                  datacard2.requestStatus=="active" ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width/1.1,
                                                        child:  TextButton(
                                                          child: const Center (child: Text('NO OFFER YET')),
                                                          onPressed: () {
                                                            active(datacard2.requestId!,"pause");
                                                            getData();
                                                            getListViewItems("active");
                                                          },
                                                        ),),

                                                    ],
                                                  ): datacard2.requestStatus=="pause" ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 2,right: 2),
                                                        width: MediaQuery.of(context).size.width/3.4,
                                                        child: TextButton(
                                                          child: const Center (
                                                              child: Text('Active')
                                                          ),
                                                          onPressed: () {
                                                            active(datacard2.requestId!, "active");
                                                            getData();
                                                            getListViewItems("active");
                                                          },
                                                        ),),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width/3.4,
                                                        child: TextButton(
                                                          child: const Center (child: Text('Dalete')),
                                                          onPressed: () {
                                                            active(datacard2.requestId!,"delete");
                                                            getData();
                                                            getListViewItems("active");
                                                          },
                                                        ),),
                                                    ],
                                                  ): datacard2.requestStatus=="pending" ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width/3.4,
                                                        child: TextButton(
                                                          child: const Center (child: Text('Dalete')),
                                                          onPressed: () {
                                                            active(datacard2.requestId!,"delete");
                                                            getData();
                                                            getListViewItems("active");
                                                          },
                                                        ),),
                                                    ],
                                                  ):Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width/3.4,
                                                        child: TextButton(
                                                          child: const Center (child: Text('Dalete')),
                                                          onPressed: () {
                                                            active(datacard2.requestId!,"delete");
                                                            getData();
                                                            getListViewItems("active");
                                                          },
                                                        ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                onTap: () {
                                },
                              )
                          );
                        }
                    ): ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: listvalues.length,
                        itemBuilder: (context, i) {
                          print("first");
                          final datacard = listvalues[i];
                          return Container(
                              padding: const EdgeInsets.only(bottom: 20),

                              margin:  const EdgeInsets.only(left: 10, right: 10,bottom: 8),
                              child: GestureDetector(
                                child: Card(
                                  elevation: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: MediaQuery.of(context).size.width/2.5,
                                                          margin:  const EdgeInsets.only(left: 10, top: 8.00,bottom: 8),
                                                          child: Text(datacard.requestDate!)),
                                                      Container(

                                                          width: MediaQuery.of(context).size.width/3,
                                                          margin:  const EdgeInsets.only(left: 10, top: 8.00,bottom: 8),
                                                          child: Container( color: primarycolor[500],
                                                              padding: const EdgeInsets.all(3),
                                                              child: Text(datacard.requestStatus!.toUpperCase(),style: const TextStyle(
                                                                color: Colors.white,

                                                                fontSize: 14,
                                                              ),textAlign: TextAlign.center,))),
                                                      Container(
                                                          width: MediaQuery.of(context).size.width/10,
                                                          margin:  const EdgeInsets.only(left: 10, top: 8.00,bottom: 8),
                                                          child: IconButton(
                                                            icon: const Icon(Icons.clear),
                                                            color: Colors.grey,
                                                            onPressed: () {
                                                              active(datacard.requestId!,"delete");

                                                              getListViewItems("active");
                                                            },
                                                          )),

                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                          padding: const EdgeInsets.all(8),
                                                          color: Colors.grey[200],
                                                          margin:  const EdgeInsets.only(bottom: 8),
                                                          width: MediaQuery.of(context).size.width/1.2,
                                                          child: Text(datacard.requestDescription!)),
                                                    ],
                                                  ),
                                                  datacard.deliveryDuration != null  ? Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:  const EdgeInsets.only(bottom: 8),
                                                          width: MediaQuery.of(context).size.width/1.2,
                                                          child:  Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: <Widget>[
                                                                const Icon(
                                                                  Icons.access_time,
                                                                ),
                                                                const Text("Duration ",style: TextStyle(
                                                                  color: Colors.black,

                                                                  fontSize: 16,
                                                                ),),
                                                                Text(datacard.deliveryDuration!,style: const TextStyle(
                                                                  color: Colors.black,

                                                                  fontSize: 16,
                                                                ),),
                                                              ])),
                                                    ],
                                                  ):const Text(""),

                                                  datacard.requestStatus=="active" ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width/1.1,
                                                        child:  TextButton(
                                                          child: const Center (child: Text('NO OFFER YET')),
                                                          onPressed: () {
                                                            active(datacard.requestId!,"pause");
                                                            getListViewItems("active");
                                                          },
                                                        ),),

                                                    ],
                                                  ): datacard.requestStatus=="pause" ? Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 2,right: 2),
                                                        width: MediaQuery.of(context).size.width/1.1,
                                                        child: TextButton(
                                                          child: const Center (
                                                              child: Text('Active')),
                                                          onPressed: () {
                                                            active(datacard.requestId!, "active");
                                                            getListViewItems("active");
                                                          },
                                                        ),),

                                                    ],
                                                  ): datacard.requestStatus=="pending" ? Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 2,right: 2),
                                                        width: MediaQuery.of(context).size.width/1.1,
                                                        child: TextButton(
                                                          child: const Center (
                                                              child: Text('Active')
                                                          ),
                                                          onPressed: () {
                                                            active(datacard.requestId!, "active");
                                                            getListViewItems("active");
                                                          },
                                                        ),),

                                                    ],
                                                  ):Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width/1.1,
                                                        child: TextButton(
                                                          child: const Center (child: Text('Dalete')),
                                                          onPressed: () {
                                                            active(datacard.requestId!,"delete");
                                                            getListViewItems("active");
                                                          },
                                                        ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                onTap: () {
                                },
                              )
                          );

                        }
                    ),

                  ),
                  Container(          color: Colors.white,
                    padding: const EdgeInsets.only(bottom: 70, top: 8.00),
                    //alignment: FractionalOffset(1.0, 1.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/1,
                    child: const Center(
                        child: Text("No Request Are Avaliable", style: TextStyle(
                          color: primarycolor,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),)
                    )
                  )
                ],
              )),

        ],
      ),
    );
  }
}
