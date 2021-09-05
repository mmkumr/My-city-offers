import 'package:city_offers_admin/ads_list.dart';
import 'package:city_offers_admin/categories.dart';
import 'package:city_offers_admin/offer_requests.dart';
import 'package:city_offers_admin/offers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Top {
  final int id;
  final String name;

  Top({
    required this.id,
    required this.name,
  });
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List dasboarditems = [
    {"title": "Normal users", "value": "100"},
    {"title": "Merchants", "value": "2584"},
    {"title": "Offer Requests", "value": "18"},
    {"title": "Offers", "value": "345"},
  ];
  List selectedTopAds = [];
  TextEditingController _category = TextEditingController();
  TextEditingController imagePrice = TextEditingController();
  TextEditingController videoPrice = TextEditingController();
  GlobalKey<FormState> addCategory = GlobalKey<FormState>();
  GlobalKey<FormState> price = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
            tabs: [
              Tab(
                icon: Icon(Icons.admin_panel_settings),
                text: "Admin panel",
              ),
              Tab(
                icon: Icon(Icons.dashboard),
                text: "Dashboard",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: ListView(
                  children: [
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Add category"),
                              content: Form(
                                key: addCategory,
                                child: TextFormField(
                                  controller: _category,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Category name",
                                    labelStyle: TextStyle(
                                      color: Color(0xff6DFFF0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
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
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    if (addCategory.currentState!.validate()) {
                                      print(_category.text);
                                    }
                                  },
                                  child: Text("Add"),
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
                        title: Text(
                          "Add Catagory",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Categories(),
                          ));
                        },
                        title: Text(
                          "Manage Catagoiries",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Offers(),
                            ),
                          );
                        },
                        title: Text(
                          "Manage Offers",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OfferRequests(),
                            ),
                          );
                        },
                        title: Text(
                          "Offer requests",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Top pinned offers"),
                              content: Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ListView(
                                  children: [
                                    Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AdsList(
                                                i: "o1",
                                              ),
                                            ),
                                          );
                                        },
                                        leading: Text("Top1"),
                                        title: Text(
                                          "Hairstyle parlour",
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AdsList(
                                                i: "o2",
                                              ),
                                            ),
                                          );
                                        },
                                        leading: Text("Top2"),
                                        title:
                                            Text("Sweets shop", softWrap: true),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AdsList(
                                                i: "o3",
                                              ),
                                            ),
                                          );
                                        },
                                        leading: Text("Top3"),
                                        title: Text("Shopping mall",
                                            softWrap: true),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    print(selectedTopAds[0].id);
                                  },
                                  child: Text("Add"),
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
                        title: Text(
                          "Top pinned offers",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Top pinned local ads"),
                              content: Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ListView(
                                  children: [
                                    Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AdsList(
                                                i: "l1",
                                              ),
                                            ),
                                          );
                                        },
                                        leading: Text("Top1"),
                                        title: Text(
                                          "Hairstyle parlour",
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AdsList(
                                                i: "l2",
                                              ),
                                            ),
                                          );
                                        },
                                        leading: Text("Top2"),
                                        title:
                                            Text("Sweets shop", softWrap: true),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AdsList(
                                                i: "l3",
                                              ),
                                            ),
                                          );
                                        },
                                        leading: Text("Top3"),
                                        title: Text("Shopping mall",
                                            softWrap: true),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    print(selectedTopAds[0].id);
                                  },
                                  child: Text("Add"),
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
                        title: Text(
                          "Top pinned Local ads",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Top pinned events"),
                              content: Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ListView(
                                  children: [
                                    Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AdsList(
                                                i: "e1",
                                              ),
                                            ),
                                          );
                                        },
                                        leading: Text("Top1"),
                                        title: Text(
                                          "Hairstyle parlour",
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AdsList(
                                                i: "e2",
                                              ),
                                            ),
                                          );
                                        },
                                        leading: Text("Top2"),
                                        title:
                                            Text("Sweets shop", softWrap: true),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AdsList(
                                                i: "e3",
                                              ),
                                            ),
                                          );
                                        },
                                        leading: Text("Top3"),
                                        title: Text("Shopping mall",
                                            softWrap: true),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    print(selectedTopAds[0].id);
                                  },
                                  child: Text("Add"),
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
                        title: Text(
                          "Top pinned events",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          "Pending interests CSV's\nfor event & local ad.",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Pricing"),
                              content: Form(
                                key: price,
                                child: Container(
                                  height: 300,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: imagePrice,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Price for picture",
                                            labelText: "Price for picture",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "The image price\nfield cannot be empty";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: videoPrice,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Price for Video/sec",
                                            labelText: "Price for Video/sec",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "The video price\nfield cannot be empty";
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
                                    if (price.currentState!.validate()) {}
                                  },
                                  child: Text("Add"),
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
                        title: Text(
                          "Pricing",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.725,
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: dasboarditems.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GridTile(
                      header: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            dasboarditems[index]["title"],
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            dasboarditems[index]["value"],
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
