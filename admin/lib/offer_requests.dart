import 'package:admin/providers/user_provider.dart';
import 'package:admin/widgets/video_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class OfferRequests extends StatefulWidget {
  OfferRequests({Key? key}) : super(key: key);

  @override
  _OfferRequestsState createState() => _OfferRequestsState();
}

class _OfferRequestsState extends State<OfferRequests> {
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
          "Offer request",
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
                          user.updateRequest(posts[index].data()["id"], "true", "Offer");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OfferRequests(),
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
                              posts[index].data()["id"], "false", "Offer");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OfferRequests(),
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
    List data = await user.postRequest("Offer");
    if (mounted)
      super.setState(() {
        posts = data;
        start = false;
      });
  }
}
