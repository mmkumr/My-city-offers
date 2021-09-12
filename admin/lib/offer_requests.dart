import 'package:admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          "Offers request",
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
                Card(
                  color: Colors.black,
                  child: ListTile(
                    title: Image.asset(
                      "assets/img/$img",
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          user.updateRequest(posts[index].data()["id"], "true");
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
                              posts[index].data()["id"], "false");
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
    List data = await user.postRequest();
    if (mounted)
      super.setState(() {
        posts = data;
        print(data.length);
      });
  }
}
