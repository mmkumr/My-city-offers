import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  List toplist = [];
  List top = [];
  bool start = true;
  List offers = [];
  List temp = [];
  @override
  Widget build(BuildContext context) {
    _firestore.collection("topEvents").get().then((value) {
      setState(() {
        toplist = value.docs[0].data()["list"];
      });
    });
    for (int i = 0; i < toplist.length && top.length < toplist.length; ++i) {
      temp = widget.list.where((element) {
        return element.data()["id"] == toplist[i];
      }).toList();
      top.insert(
        i,
        temp[0],
      );
    }
    widget.list.removeWhere((element) => element.data()["top"]);
    setState(() {
      offers = top + widget.list;
    });
    return Container(
      height: MediaQuery.of(context).size.height * 0.725,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.list.length == 0 ? 0 : widget.list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Flexible(
                child: GridTile(
                  child: widget.list[index].data()["fileType"] == "Video"
                      ? widget.list[index].data()["url"] == null
                          ? Container()
                          : VideoItems(
                              videoPlayerController:
                                  VideoPlayerController.network(
                                widget.list[index].data()["url"],
                              ),
                              looping: false,
                              autoplay: false,
                            )
                      : widget.list[index].data()["url"] == null
                          ? Container()
                          : Container(
                              height: 250,
                              child: Image.network(
                                widget.list[index].data()["url"],
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
                        onPressed: () {},
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
                        onPressed: () {},
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
