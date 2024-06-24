import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cowdiar/util/manage.dart';
import 'package:cowdiar/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SellingOrder extends StatefulWidget {
  const SellingOrder({super.key});

  @override
  _SellingOrderState createState() => _SellingOrderState();
}

class _SellingOrderState extends State<SellingOrder> {

  int _selectedIndex = 0;
  String token = "";
  List<StatusArr> listSCArr = [];
  List<MOrdersArr> listvalues = [];
  List<MOrdersArr> listdeafultval = [];
  String items="all";
  var loading = false;
  var loading2= false;
  Future<Null> getListViewItems(String items) async{
    listvalues.clear();
    setState(() {
      loading2 = true;
    });
    print(items);
    print(token);
    final responseData = await http.post( Uri.parse(baseurl + version  + sellingorder),
        body: {"status": items},
        headers: {'Auth': token});


    if (responseData.statusCode == 200) {

      final data = responseData.body;
      var listvalue = jsonDecode(data)['content']['mOrdersArr'] as List;

      setState(() {
        for (Map i in listvalue) {
          listvalues.add(MOrdersArr.fromMap(i as Map<String, dynamic>));
        }
        loading2 = false;

        print(listvalues.length);
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
    final responseData = await http.get( Uri.parse(baseurl + version  + sellingorder), headers: {'Auth': token});
    if (responseData.statusCode == 200) {

      final data = responseData.body;
      var listsCArr = jsonDecode(data)['content']['statusArr'] as List;
      var listdeafult = jsonDecode(data)['content']['mOrdersArr'] as List;
      setState(() {
        for (Map i in listsCArr) {
          listSCArr.add(StatusArr.fromMap(i as Map<String, dynamic>));
        }
        for (Map i in listdeafult) {
          listdeafultval.add(MOrdersArr.fromMap(i as Map<String, dynamic>));
        }
        loading2 = false;
        loading = false;
      });

    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getListViewItems(items);
  }

  _onSelected(int index) {
    setState(() => _selectedIndex = index
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(

        title: const Text("Manage Orders"),
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
                  itemCount: 5,
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
                              "${nDataList.status!.substring(0,1).toUpperCase()}${nDataList.status!.substring(1)} (${nDataList.count})",
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
                        getListViewItems(nDataList.status!);
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
              ):Column(
                children: <Widget>[

                  Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(bottom: 70, top: 8.00),
                      //alignment: FractionalOffset(1.0, 1.0),
                      width: MediaQuery.of(context).size.width,
                      height: listvalues.isEmpty && listdeafultval.isEmpty ? 1:MediaQuery.of(context).size.height/1.1,
                      child:  listvalues.isEmpty ?
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: listdeafultval.length,

                          itemBuilder: (context, i) {
                            final datacard2 = listdeafultval[i];
                            print(datacard2.orderStatus);
                            return Container(
                                decoration:const BoxDecoration(


                                ),
                                padding: const EdgeInsets.only(top:3,bottom: 3),
                                margin:  const EdgeInsets.only(left: 10, right: 8.00),
                                child: Card(
                                  child: Container(
                                    padding: const EdgeInsets.only(top:5,bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[

                                                Container(
                                                    padding: const EdgeInsets.only(top:3,bottom: 3),
                                                    margin:  const EdgeInsets.only(left: 10, top: 8.00),
                                                    width: MediaQuery.of(context).size.width/5,
                                                    height: MediaQuery.of(context).size.height/10,

                                                    decoration: BoxDecoration(

                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                                datacard2.postImage!)
                                                        )
                                                    )),
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(context).size.width/3.6,
                                                        margin:  const EdgeInsets.only(left: 10, top: 8.00),
                                                        child: Text(datacard2.sellerName!,style: const TextStyle(
                                                          color: Colors.black,

                                                          fontSize: 16,
                                                        ),textAlign: TextAlign.left,)),
                                                    Container(
                                                        width: MediaQuery.of(context).size.width/2.8,
                                                        margin:  const EdgeInsets.only(left: 10, top: 8.00),
                                                        child: Text(datacard2.orderDate!,style: const TextStyle(
                                                          color: Colors.grey,

                                                          fontSize: 14,
                                                        ),textAlign: TextAlign.right)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        padding: const EdgeInsets.only(top:13,bottom: 13),
                                                        width: MediaQuery.of(context).size.width/1.6,
                                                        margin:  const EdgeInsets.only(left: 10, top: 0.00),
                                                        child: Text(datacard2.postTitle!,style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 16,
                                                        ),textAlign: TextAlign.left,)),
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                        padding: const EdgeInsets.all(4),
                                                        decoration:BoxDecoration(
                                                          border: Border.all(
                                                            color: primarycolor,
                                                            width: 2,
                                                          ),

                                                        ),

                                                        child: Text(datacard2.orderStatus == "cancellation requested" ? "cancellation" :datacard2.orderStatus!,style: const TextStyle(
                                                          color: primarycolor,

                                                          fontSize: 16,
                                                        ),textAlign: TextAlign.left)),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/3.9,
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(context).size.width/7,
                                                        child: Text(datacard2.orderPrice!,style: const TextStyle(
                                                          color: primarycolor,

                                                          fontSize: 16,
                                                        ),textAlign: TextAlign.right)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            );
                          }
                      ): ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: listvalues.length,

                          itemBuilder: (context, i) {
                            final datacard = listvalues[i];
                            print("first");
                            return Container(
                                decoration:const BoxDecoration(


                                ),
                                padding: const EdgeInsets.only(top:3,bottom: 3),
                                margin:  const EdgeInsets.only(left: 10, right: 8.00),
                                child: Card(
                                  child: Container(
                                    padding: const EdgeInsets.only(top:5,bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[

                                                Container(
                                                    padding: const EdgeInsets.only(top:3,bottom: 3),
                                                    margin:  const EdgeInsets.only(left: 10, top: 8.00),
                                                    width: MediaQuery.of(context).size.width/5,
                                                    height: MediaQuery.of(context).size.height/10,

                                                    decoration: BoxDecoration(

                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                                datacard.postImage!)
                                                        )
                                                    )),
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(context).size.width/3.6,
                                                        margin:  const EdgeInsets.only(left: 10, top: 8.00),
                                                        child: Text(datacard.sellerName!.length > 12 ? datacard.sellerName!.substring(0,12) : datacard.sellerName!,style: const TextStyle(
                                                          color: Colors.black,

                                                          fontSize: 16,
                                                        ),textAlign: TextAlign.left,)),
                                                    Container(
                                                        width: MediaQuery.of(context).size.width/2.8,
                                                        margin:  const EdgeInsets.only(left: 10, top: 8.00),
                                                        child: Text(datacard.orderDate!,style: const TextStyle(
                                                          color: Colors.grey,

                                                          fontSize: 14,
                                                        ),textAlign: TextAlign.right)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        padding: const EdgeInsets.only(top:13,bottom: 13),
                                                        width: MediaQuery.of(context).size.width/1.6,
                                                        margin:  const EdgeInsets.only(left: 10, top: 0.00),
                                                        child: Text(datacard.postTitle!,style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 16,
                                                        ),textAlign: TextAlign.left,)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        padding: const EdgeInsets.all(4),
                                                        decoration:BoxDecoration(
                                                          border: Border.all(
                                                            color: primarycolor,
                                                            width: 2,
                                                          ),

                                                        ),

                                                        child: Text(datacard.orderStatus == "cancellation requested" ? "cancellation" :datacard.orderStatus!,style: const TextStyle(
                                                          color: primarycolor,

                                                          fontSize: 16,
                                                        ),textAlign: TextAlign.left)),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/3.9,
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(context).size.width/7,
                                                        child: Text(datacard.orderPrice!,style: const TextStyle(
                                                          color: primarycolor,

                                                          fontSize: 16,
                                                        ),textAlign: TextAlign.right)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            );
                          }
                      )
                  ),
                  Container(          color: Colors.white,
                      padding: const EdgeInsets.only(bottom: 70, top: 8.00),
                      //alignment: FractionalOffset(1.0, 1.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/1,
                      child: const Center(
                          child: Text("No Order Avaliable", style: TextStyle(
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
