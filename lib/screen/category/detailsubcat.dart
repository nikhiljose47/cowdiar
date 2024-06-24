import 'package:flutter/material.dart';
import 'package:cowdiar/screen/category/category.dart';
import 'package:cowdiar/screen/details/catdetail.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cowdiar/services/api.dart';
import 'package:cowdiar/util/subcat.dart';

class subcatDetails extends StatefulWidget {
  final String subcatlink, title;//if you have multiple values add here
  const subcatDetails(this.subcatlink, this.title, {super.key});

  @override
  _subcatDetailsState createState() => _subcatDetailsState();
}

class _subcatDetailsState extends State<subcatDetails> {
  List<SCArr> listSCArr = [];
  var loading = false;
  String? topimage;

  Future<Null> getData() async {
    setState(() {
      loading = true;
    });
    final linkdata = '/${widget.subcatlink}';
    print(baseurl + version  + linkdata);
    final responseData = await http.get(Uri.parse(baseurl + version  + linkdata));
    if (responseData.statusCode == 200) {

      final data = responseData.body;
      var listsCArr = jsonDecode(data)['content']['sCArr'] as List;

      var bImage = jsonDecode(data)['content']['bImage'] ;
      setState(() {
        print("object");
        for (Map i in listsCArr) {
          listSCArr.add(SCArr.fromMap(i as Map<String, dynamic>));
        }
        topimage = jsonDecode(data)['content']['bImage'];
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // print(topimage);
    // Widget image(){
    //   if (topimage != null) {
    //     return
    //       Expanded(
    //         flex: 1,
    //         child: Container(
    //           height: 200.0,
    //           decoration: BoxDecoration(
    //             color: Colors.grey,
    //             image: DecorationImage(
    //               image: NetworkImage(
    //                 topimage,
    //               ),
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //         ),
    //       );
    //   }
    // }

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () =>  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => const category())),
            ),
          title: Text(widget.title),
          centerTitle: true,

        ),
        body: loading
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primarycolor)))
            : ListView(
          children: [
            Column(
              children: <Widget>[
                // loading
                //     ? Center()
                //     : Container(
                //     height: 200,
                //     child: Row(
                //         children: <Widget>[image(),]
                //     )
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height-30,
                  child: loading
                      ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primarycolor)))
                      : ListView.builder(

                    scrollDirection: Axis.vertical,
                    primary: false,
                    itemCount: listSCArr.length,
                    itemBuilder: (context, i) {
                      final nDataList = listSCArr[i];
                      return Container(
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
                          title: Text(nDataList.title!),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            print("nikil${nDataList.link}");
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context){
                                  return catdetail(nDataList.link!, nDataList.title!, widget.subcatlink,widget.title);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        )

    );
  }
}
