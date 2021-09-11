import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'edit_item.dart';
import 'providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
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
  List videos = [];
  bool start = true;
  @override
  Widget build(BuildContext context) {
    if (start) {
      getPosts();
      setState(() {
        start = false;
      });
    }
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
                                ? videos.length != posts.length
                                    ? Container()
                                    : Image.file(
                                        File(videos[index]),
                                      )
                                : posts[index].data()["url"] == null
                                    ? Container()
                                    : Image.asset(
                                        "assets/img/offer.jpg") /*Image.network(
                                      posts[index].data()["url"],
                                    ),*/
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
                                      .data()["verified"]
                                      .add(Duration(days: 10))
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
                        onPressed: () {
                          user.deletePost(posts[index].data()["id"]);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageItems()
                            ),
                          );
                        },
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
    List data = await user.getPosts();

    if (mounted)
      super.setState(() {
        posts = data;
      });
    for (int i = 0; i < posts.length; ++i) {
      if (posts[i].data()["fileType"] == "Video") {
        var data = (await VideoThumbnail.thumbnailFile(
          video:
              "https://github.com/mmkumr/pictures/blob/master/DG%20Medical%20Animations_%2030%20second%20demo%20compilation.mp4?raw=true",
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.PNG,
          maxHeight: 150,
          quality: 70,
        ));
        if (mounted)
          setState(() {
            videos.insert(i, data);
          });
      } else {
        if (mounted)
          setState(() {
            videos.insert(i, "null");
          });
      }
    }
  }
}
