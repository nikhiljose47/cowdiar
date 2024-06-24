import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cowdiar/screen/profiledetails/profiledetails.dart';
import 'package:http/http.dart' as http;
import 'package:cowdiar/services/api.dart';
import 'package:cowdiar/util/searchcall.dart';
import 'package:cowdiar/Widget/recentvariable.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController editingController = TextEditingController();
  List<PList> listplaces = [];
  final ScrollController _scrollController = ScrollController();

  onSearchTextChanged(String text) async {
    listplaces.clear();
    String text = editingController.text;
    print(text);

    final responseData = await http.post(Uri.parse(baseurl + version + searchurl), body: {
      "search_string": text,
    });
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listpalces = jsonDecode(data)['content']['pList'] as List;
      print(listpalces);
      setState(() {
        for (Map i in listpalces) {
          listplaces.add(PList.fromMap(i as Map<String, dynamic>));
        }
      });
    }
  }

  Future _printLatestValue() async {
    String text = editingController.text;
    final responseData = await http.post(Uri.parse(baseurl + version + searchurl), body: {
      "search_string": text,
    });
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      var listpalces = jsonDecode(data)['content']['pList'] as List;
      print(listpalces);
      setState(() {
        for (Map i in listpalces) {
          listplaces.add(PList.fromMap(i as Map<String, dynamic>));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _printLatestValue();
  }

  myBoxDecorationfirst() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(
          color: Colors.grey, width: 0.5, style: BorderStyle.solid),
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(10.0),
        //bottom: new Radius.circular(20.0),
      ),
    );
  }

  final bottomContentText = Container(
    padding: const EdgeInsets.only(left: 10.00, top: 10.00, bottom: 10.00),
    child: Column(
      children: <Widget>[
        const Row(
          children: <Widget>[
            Text(
              "Shop By",
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Style",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Seller's Experience",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Editiable",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget grid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.1),
      ),
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          final nplacesList = listplaces[i];
          return GestureDetector(
            child: Card(
              elevation: 0.0,
              child: Container(
                // margin: EdgeInsets.only(left: 5.00, top: 5.00, right: 5.00),
                decoration: myBoxDecorationfirst(),

                child: Column(children: <Widget>[
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.network(
                        nplacesList.postImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 10.00, right: 10.00, top: 5.00, bottom: 5.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            nplacesList.sellerImage!)))),
                            Container(
                                padding: const EdgeInsets.only(left: 5.00),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(nplacesList.sellerName!),
                                      Text(nplacesList.sellerLevel!),
                                    ])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10.00, left: 10.00),
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 5),
                              child: Text(nplacesList.title!.length > 30
                                  ? "${nplacesList.title!.substring(0, 30)}..."
                                  : nplacesList.title!),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(right: 10.00, top: 10.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              "${nplacesList.rating!.totalReviews} ",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.orangeAccent,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "(${nplacesList.rating!.averageRatting})",
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
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return profiledetailpage(nplacesList.link!, "search",
                        "search", "search", "search");
                  },
                ),
              );
            },
          );
        },
        childCount: listplaces.length,
      ),
    );
  }

  Card customersec(Recent recent) => Card(
        child: Container(
          // margin: EdgeInsets.only(left: 5.00, top: 5.00, right: 5.00),

          // height: 1000,
          width: 250,
          decoration: myBoxDecorationfirst(),

          child: Column(children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.asset(
                  "${recent.coverimg}",
                  height: 167,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 10.00, right: 10.00, top: 10.00, bottom: 5.00),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(recent.profileimg!)))),
                      Container(
                        padding: const EdgeInsets.only(left: 5.00),
                        child: Text(recent.name!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.00, left: 10.00),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 5),
                        child: Text(recent.description!),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.00, left: 10.00, top: 10.00),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                              "${recent.price}",
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
                        "${recent.rating} ",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.orangeAccent,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "(${recent.ratingcount})",
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
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                elevation: 1.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 250,
                      height: 45,
                      child: TextField(
                        onChanged: onSearchTextChanged,
                        controller: editingController,
                        decoration: const InputDecoration(
                          hintText: "Search",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black38,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                                style: BorderStyle.none),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Text("dfdfdf"),
          ],
        ),
      ),
      body: CustomScrollView(controller: _scrollController, slivers: <Widget>[
        grid(),
      ]),
    );
  }
}
