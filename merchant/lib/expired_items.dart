import 'package:flutter/material.dart';
import 'package:merchant/providers/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ExpiredItems extends StatefulWidget {
  ExpiredItems({Key? key}) : super(key: key);

  @override
  _ExpiredItemsState createState() => _ExpiredItemsState();
}

class _ExpiredItemsState extends State<ExpiredItems> {
  GlobalKey<FormState> ExpiredItem = GlobalKey<FormState>();
  TextEditingController _days = TextEditingController();
  List posts = [];
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
          "Expired items",
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
                    title: Image.asset(
                      "assets/img/$img",
                    ),
                    subtitle: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Expiry date: $expiry",
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
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Extend date"),
                              content: Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Form(
                                  key: ExpiredItem,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: _days,
                                          keyboardType:
                                              TextInputType.numberWithOptions(),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText:
                                                "Validity of the ad in days",
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "This field cannot be empty.";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    if (ExpiredItem.currentState!.validate()) {
                                      user.updatedate(posts[index].data()["id"],
                                          _days.text);
                                      ExpiredItem.currentState!.reset();
                                      _days.clear();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ExpiredItems(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text("Extend"),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("cancel"),
                                ),
                              ],
                            ),
                          );
                        },
                        color: Colors.amber,
                        child: Text(
                          "Extend date",
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
        try {
          posts = data.where((element) {
            return element
                .data()["vdate"]
                .toDate()
                .add(
                  Duration(
                    days: int.parse(
                      element.data()["days"],
                    ),
                  ),
                )
                .isBefore(DateTime.now());
          }).toList();
        } catch (e) {
          print(e);
        }
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
