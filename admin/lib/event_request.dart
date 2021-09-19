import 'package:admin/providers/user_provider.dart';
import 'package:admin/widgets/video_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class EventRequests extends StatefulWidget {
  EventRequests({Key? key}) : super(key: key);

  @override
  _EventRequestsState createState() => _EventRequestsState();
}

class _EventRequestsState extends State<EventRequests> {
  GlobalKey<FormState> updateCategory = GlobalKey<FormState>();
  TextEditingController _category = TextEditingController();
  List posts = [];
  bool start = true;
  @override
  Widget build(BuildContext context) {
    if (start) {
      getPosts();
    }
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          "Event request",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          String img;
          if (index % 2 == 0) {
            img = "local_ad.png";
          } else {
            img = "offer.jpg";
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Type: " + posts[index].data()["promotionType"],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: posts[index].data()["fileType"] == "Video"
                      ? VideoItems(
                          videoPlayerController: VideoPlayerController.network(
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Expiry date: " + posts[index].data()["days"].toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          user.updateRequest(
                              posts[index].data()["id"], "true", "Event");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventRequests(),
                            ),
                          );
                        },
                        color: Colors.amber,
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          user.updateRequest(
                              posts[index].data()["id"], "false", "Event");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventRequests(),
                            ),
                          );
                        },
                        color: Colors.amber,
                        child: Text(
                          "Reject",
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
    List data = await user.postRequest("Event");
    if (mounted)
      super.setState(() {
        posts = data;
        start = false;
      });
  }
}
