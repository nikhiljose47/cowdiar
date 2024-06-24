import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cowdiar/services/api.dart';
import 'dart:convert';
import 'package:cowdiar/util/inboxdetails.dart';
import 'package:path_provider/path_provider.dart';

class Inboxdetailpage extends StatefulWidget {
  final String messagegropid, sellname; //if you have multiple values add here
  const Inboxdetailpage(this.messagegropid, this.sellname, {super.key});

  @override
  _InboxdetailpageState createState() => _InboxdetailpageState();
}

class _InboxdetailpageState extends State<Inboxdetailpage> {
  String? imgUrl;

  bool downloading = false;
  var progressString = "";
  String progress = '0';
  ScrollController _scrollController = ScrollController();
  File? _file;
  final bool _showBottom = false;
  final String _fileName = '...';
  final _key = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  Color myGreen = const Color(0xff4bb17b);

  var? textvalue;
  List<ConversationArr> friendsLists = [];

  var loading = false;
  String? topimage;
  String token = "";

  Future<void> downloadFile(imgUrl) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      await dio.download(imgUrl, dir.path,
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = "${((rec / total) * 100).toStringAsFixed(0)}%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  Future getFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    File file = File(result.files.single.path);

    setState(() {
      _file = file;
    });
  }

  void _uploadFile(filePath) async {
    final form = _key.currentState;
    form.save();

    print("textvalue");
    print(textvalue);
    print(filePath);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    setState(() {
      loading = true;
    });
    if (filePath != null) {
      String fileName = basename(filePath.path);
      print("file base name:$fileName");

      try {
        FormData formData = FormData.fromMap({
          'message_group_id': widget.messagegropid,
          'message': textvalue,
          'file':
              await MultipartFile.fromFile(filePath.path, filename: fileName),
        });

        Response response = await Dio().post(
          baseurl + version + inboxsend,
          data: formData,
          options: Options(
            headers: {
              'Auth': token, // set content-length
            },
          ),
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          setState(() {
            getData();
          });
        }
        // loading = false;
        print("File upload response: $response");

        print(response.data['message']);
      } catch (e) {
        print("expectation Caugch: $e");
      }
    } else {
      try {
        FormData formData = FormData.fromMap({
          'message_group_id': widget.messagegropid,
          'message': textvalue,
          'file': '',
        });

        Response response = await Dio().post(
          baseurl + version + inboxsend,
          data: formData,
          options: Options(
            headers: {
              'Auth': token, // set content-length
            },
          ),
        );
        if (response.statusCode == 200) {
          setState(() {
            getData();
          });
        }
        //  loading = false;
        print("File upload response: $response");
        print(response.statusCode);
        print(response.data['message']);
      } catch (e) {
        print("expectation Caugch: $e");
      }
    }
  }

  Future<Null> getData() async {
    friendsLists.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    print(token);
    setState(() {
      loading = true;
    });
    final linkdata = widget.messagegropid;
    print("jjjk");
    print(linkdata);
    print(baseurl + version + inboxdetails);
    final responseData =
        await http.post(Uri.parse(baseurl + version + inboxdetails), body: {
      'message_group_id': widget.messagegropid,
    }, headers: {
      'Auth': token
    });
    if (responseData.statusCode == 200) {
      print("sasaas");
      final data = responseData.body;
      var friendsList = jsonDecode(data)['content']['conversationArr'] as List;

      setState(() {
        _file = null;
        for (Map i in friendsList) {
          friendsLists.add(ConversationArr.fromMap(i as Map<String, dynamic>));
        }
        loading = false;
      });
    }
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.pixels);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
            child: Center(child: Text(widget.sellname))),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primarycolor)))
          : Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: friendsLists.length,
                          controller: _scrollController,
                          reverse: true,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            final listcat = friendsLists[i];

                            return ListTile(
                              leading: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              listcat.senderImage)))),
                              title: Container(
                                  padding: const EdgeInsets.only(top: 10, bottom: 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Text(
                                            listcat.senderName,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            child: Text(
                                          listcat.dateTime,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        )),
                                      ]),
                                      Text(
                                        listcat.message,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      listcat.filetype == null
                                          ? Text(
                                              listcat.filename,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            )
                                          : Container(
                                              height: 0,
                                            ),
                                      listcat.filetype == "image"
                                          ? Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          listcat
                                                              .messageFile))))
                                          : Container(
                                              height: 0,
                                            ),
                                    ],
                                  )),
                              //subtitle: Text((listsubcat[i].subCategoryTitle[i])),
                            );
                          },
                        ),
                      ),
                      Form(
                          key: _key,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  //                   <--- top side
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.only(
                                top: 0.0, bottom: 0.0, right: 5.0, left: 5.0),
                            margin: const EdgeInsets.only(
                                top: 3.0, bottom: 0.0, right: 0.0, left: 0.0),
                            height: 100,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: TextFormField(
                                            onSaved: (e) => textvalue = e,
                                            style: const TextStyle(
                                              height: 1,
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'SophiaNubian',
                                            ),
                                            decoration: const InputDecoration(
                                                hintText: "Type a Message...",
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        Container(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.attachment),
                                                      color: primarycolor,
                                                      onPressed: () {
                                                        getFile();
                                                      },
                                                    ),
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                      "send",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: primarycolor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            'SophiaNubian',
                                                      ),
                                                    ),
                                                    
                                                    onPressed: () {
                                                      _uploadFile(_file);
                                                    },
                                                  ),
                                                ]))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
