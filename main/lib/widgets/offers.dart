import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'video_items.dart';

class Offers extends StatefulWidget {
  List list;
  Offers({Key? key, required this.list}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List toplist = [];
  List top = [];
  bool start = true;
  List offers = [];
  List temp = [];
  @override
  Widget build(BuildContext context) {
    _firestore.collection("topOffers").get().then((value) {
      setState(() {
        toplist = value.docs[0].data()["list"];
      });
    });
    for (int i = 0;
        i < toplist.length && top.length < toplist.length;
        ++i) {
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
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.725,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: offers.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Flexible(
                child: GridTile(
                  child: offers[index].data()["fileType"] == "Video"
                      ? VideoItems(
                          videoPlayerController: VideoPlayerController.network(
                            offers[index].data()["url"],
                          ),
                          looping: false,
                          autoplay: false,
                        )
                      : offers[index].data()["url"] == null
                          ? Container()
                          : Container(
                              height: 250,
                              child: Image.network(
                                offers[index].data()["url"],
                              ),
                            ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.white70,
                      onPressed: () {},
                      child: Text("Details"),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                  ),
                  Expanded(
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.white70,
                      onPressed: () {},
                      child: Text("Interested"),
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
