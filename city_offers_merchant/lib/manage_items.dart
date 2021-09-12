import 'dart:typed_data';

import 'package:city_offers_merchant/edit_item.dart';
import 'package:city_offers_merchant/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ManageItems extends StatefulWidget {
  ManageItems({Key? key}) : super(key: key);

  @override
  _ManageItemsState createState() => _ManageItemsState();
}

class _ManageItemsState extends State<ManageItems> {
  GlobalKey<FormState> updateItem = GlobalKey<FormState>();
  TextEditingController _item = TextEditingController();
  TextEditingController _days = TextEditingController();
  List posts = [];
  String? thumb;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getPosts();
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          "Manage items",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          if (posts[index].data()["fileType"] == "Video") {
            getThumb(posts[index].data()["url"]);
          }
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Card(
                  color: Colors.black,
                  child: ListTile(
                    title: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "id: " + posts[index].data()["id"],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          child: posts[index].data()["fileType"] == "Video"
                              ? thumb == null
                                  ? Container()
                                  : Image.asset(thumb!)
                              : Image.network(
                                  posts[index].data()["url"],
                                ),
                        ),
                      ],
                    ),
                    subtitle: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          posts[index].data()["verified"] == 0
                              ? "Not verified by admin"
                              : "Expiry date: " +
                                  posts[index]
                                  .data()["vdate"]
                                  .toDate()
                                  .add(
                                    Duration(
                                      days: int.parse(
                                          posts[index].data()["days"]),
                                    ),
                                  )
                                  .toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditItem(),
                            ),
                          );
                        },
                        color: Colors.amber,
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {},
                        color: Colors.amber,
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  getPosts() async {
    final user = Provider.of<UserProvider>(context);
    List<DocumentSnapshot> data = await user.getPosts();

    if (mounted)
      super.setState(() {
        posts = data;
      });
  }

  getThumb(String url) async {
    var data = (await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    ));
    setState(() {
      print(data);
      thumb = data;
    });
  }
}
