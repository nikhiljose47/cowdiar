import 'package:flutter/material.dart';
import 'package:cowdiar/screen/mainscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cowdiar/util/categore.dart';
import 'package:cowdiar/services/api.dart';
import 'package:cowdiar/screen/category/detailsubcat.dart';

class category extends StatefulWidget {
  const category({super.key});

  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<category> {
  List<CArr> listService = [];
  List<SCArr> listsubcat = [];
  var loading = false;

  Future<Null> getData() async {
    setState(() {
      loading = true;
    });
    final responseData = await http.get(Uri.parse(baseurl + version + categorylink));
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listservices = jsonDecode(data)['content']['cArr'] as List;

      var subcat = jsonDecode(data)['content']['cArr'][0]['sCArr'] as List;
      setState(() {
        for (Map i in listservices) {
          listService.add(CArr.fromMap(i as Map<String, dynamic>));
          //print(listservices);

        }

        for (Map i in subcat) {
          listsubcat.add(SCArr.fromMap(i as Map<String, dynamic>));
          //print(listsubcat);
        }
        loading = false;
      });
    }
  }

  //Panggil Data / Call Data
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const MyHomePage(0))),
        ),
        leadingWidth: 20,
        actions: <Widget>[
           searchsec(context),
        ],
      ),
      body: ListView(children: [
        Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 20, top: 20.00),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                primarycolor)))
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        primary: false,
                        itemCount: listService.length,
                        itemBuilder: (context, i) {
                          final nDataList = listService[i];
                          return nDataList.image == null
                              ? Container()
                              : Container(
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
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image(
                                        image: NetworkImage(
                                          nDataList.image!,
                                        ),
                                        height: 30,
                                        width: 30,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    title: Container(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(nDataList.title!),
                                            Text(
                                              listService[i]
                                                          .sCArr[0]
                                                          .subCategoryTitle ==
                                                      null
                                                  ? '${listService[i]
                                                          .sCArr[0]
                                                          .subCategoryTitle} , ${listService[i]
                                                          .sCArr[1]
                                                          .subCategoryTitle}'
                                                  : "",
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    //subtitle: Text((listsubcat[i].subCategoryTitle[i])),
                                    trailing: const Icon(Icons.keyboard_arrow_right),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return subcatDetails(nDataList.link,
                                                nDataList.title);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                        },
                      ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

Widget searchsec(context) {
  return Row(
    children: <Widget>[
      Container(
        margin: const EdgeInsets.only(top: 8.00, right: 5.00, bottom: 8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Colors.grey, width: 1.0, style: BorderStyle.solid),
            borderRadius:
                const BorderRadius.all(Radius.circular(10.0))),
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.only(left: 10.00, right: 65),
            height: 40,
            child: const Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  size: 20.0,
                  color: Colors.black,
                ),
                Text("  What are you looking for?"),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(2)),
            );
          },
        ),
      ),
    ],
  );
}
