import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merchant/widgets/video_items.dart';
import 'package:video_player/video_player.dart';
import 'providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ManageEvents extends StatefulWidget {
  ManageEvents({Key? key}) : super(key: key);

  @override
  _ManageEventsState createState() => _ManageEventsState();
}

class _ManageEventsState extends State<ManageEvents> {
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
          "Manage Events",
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
                    onLongPress: () {
                      Clipboard.setData(
                        new ClipboardData(
                          text: posts[index].data()["id"],
                        ),
                      );
                      Fluttertoast.showToast(
                        msg: "Post id copied to clipboard",
                      );
                    },
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "type: " + posts[index].data()["promotionType"],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          child: posts[index].data()["fileType"] == "Video"
                              ? posts[index].data()["url"] == null
                                  ? Container()
                                  : VideoItems(
                                      videoPlayerController:
                                          VideoPlayerController.network(
                                        posts[index].data()["url"],
                                      ),
                                      looping: false,
                                      autoplay: false,
                                    )
                              : posts[index].data()["url"] == null
                                  ? Container()
                                  : Container(
                                      height: 250,
                                      child: Image.network(
                                        posts[index].data()["url"],
                                      ),
                                    ),
                        ),
                      ],
                    ),
                    subtitle: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          posts[index].data()["verified"] == "0"
                              ? "Not verified by admin"
                              : "Expiry date: " +
                                  (posts[index].data()["vdate"].toDate().add(
                                        Duration(
                                          days: int.parse(
                                            posts[index].data()["days"],
                                          ),
                                        ),
                                      )).toString(),
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
                          user.deletePost(posts[index].data()["id"], "Event");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageEvents()),
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
    List data = await user.getPosts("Event");

    if (mounted)
      super.setState(() {
        posts = data;
      }); 
  }
}
