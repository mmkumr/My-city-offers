import 'package:admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Offers extends StatefulWidget {
  Offers({Key? key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
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
          "Offers",
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
                        Image.asset(
                          "assets/img/$img",
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
                          user.deletePost(posts[index].data()["id"]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Offers(),
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
    user.getPosts().then((value) {
      if (mounted)
        super.setState(() {
          posts = value;
        });
    });
  }
}
