import 'package:admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'widgets/video_items.dart';

class LocalAds extends StatefulWidget {
  LocalAds({Key? key}) : super(key: key);

  @override
  _LocalAdsState createState() => _LocalAdsState();
}

class _LocalAdsState extends State<LocalAds> {
  List posts = [];
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
          "Local Ads",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          String img;
          String expiry;
          if (index % 2 == 0) {
            img = "local_ad.png";
            expiry = "22/06/2021";
          } else {
            img = "offer.jpg";
            expiry = "10/03/2021";
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
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
                            "Type of post: " +
                                posts[index].data()["promotionType"],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          child: posts[index].data()["fileType"] == "Video"
                              ? VideoItems(
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
                          "Expiry date: " +
                              posts[index]
                                  .data()["vdate"]
                                  .toDate()
                                  .add(
                                    Duration(
                                      days: int.parse(
                                        posts[index].data()["days"],
                                      ),
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
                          user.deletePost(posts[index].data()["id"], "Local Ad");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocalAds(),
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

  getPosts() {
    final user = Provider.of<UserProvider>(context);
    user.getPosts("Local Ad").then((value) {
      if (mounted)
        super.setState(() {
          posts = value;
        });
    });
  }
}
