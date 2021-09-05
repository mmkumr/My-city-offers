import 'package:city_offers_merchant/edit_item.dart';
import 'package:flutter/material.dart';

class ManageItems extends StatefulWidget {
  ManageItems({Key? key}) : super(key: key);

  @override
  _ManageItemsState createState() => _ManageItemsState();
}

class _ManageItemsState extends State<ManageItems> {
  GlobalKey<FormState> updateItem = GlobalKey<FormState>();
  TextEditingController _item = TextEditingController();
  TextEditingController _days = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
        itemCount: 20,
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
}
