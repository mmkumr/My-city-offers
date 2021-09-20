import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:main/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'video_items.dart';

class Events extends StatefulWidget {
  List list;
  Events({Key? key, required this.list}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List topList = [];
  List top = [];
  bool start = true;
  List totalList = [];
  String ref = "topEvent";
  String doc = "qunSkah202XkhkKPvPAW";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    if (start) {
      _firestore.collection(ref).doc(doc).get().then((value) {
        topList = value.data()!["list"];
        for (int i = 0; i < topList.length; ++i) {
          topList[i].get().then((value) {
            setState(() {
              top.insert(i, value);
            });
          });
        }
      });
      setState(() {
        totalList = top + widget.list.reversed.toList();
        start = false;
      });
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.725,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: totalList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Flexible(
                child: GridTile(
                  child: totalList[index].data()["fileType"] == "Video"
                      ? totalList[index].data()["url"] == null
                          ? Container()
                          : VideoItems(
                              videoPlayerController:
                                  VideoPlayerController.network(
                                totalList[index].data()["url"],
                              ),
                              looping: false,
                              autoplay: false,
                            )
                      : totalList[index].data()["url"] == null
                          ? Container()
                          : Container(
                              height: 250,
                              child: Image.network(
                                totalList[index].data()["url"],
                              ),
                            ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.white70,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Description",
                                textAlign: TextAlign.center,
                              ),
                              content:
                                  Text(totalList[index].data()["description"]),
                            ),
                          );
                        },
                        child: Text("Details"),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                  ),
                  Expanded(
                    child: Center(
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.white70,
                        onPressed: () {
                          user.updateInterests(
                              "Offer",
                              totalList[index].data()["id"],
                              user.userDetails["userId"]);
                          Fluttertoast.showToast(
                              msg: "Thanks for showing interest");
                        },
                        child: Text("Interested"),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
