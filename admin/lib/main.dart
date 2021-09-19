import 'package:admin/event_request.dart';
import 'package:admin/events.dart';
import 'package:admin/localAds.dart';
import 'package:admin/localAds_requests.dart';
import 'package:admin/providers/user_provider.dart';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'categories.dart';
import 'offer_requests.dart';
import 'offers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider.initialize(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Home(),
      ),
    ),
  );
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
  Algolia _algoliaApp = Algolia.init(
    applicationId: 'IGCCEEE2PN', //ApplicationID,
    apiKey: 'cd9cd84a191e989f312739113d07d56a', //admin api key in flutter code
  );
  List selectedTopAds = [];
  TextEditingController _category = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _area = TextEditingController();
  List<TextEditingController> to = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  List<TextEditingController> tl = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  List<TextEditingController> te = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  GlobalKey<FormState> addCategory = GlobalKey<FormState>();
  GlobalKey<FormState> addPlace = GlobalKey<FormState>();
  GlobalKey<FormState> price = GlobalKey<FormState>();
  GlobalKey<FormState> topEvents = GlobalKey<FormState>();
  GlobalKey<FormState> topLocalAds = GlobalKey<FormState>();
  GlobalKey<FormState> topOffers = GlobalKey<FormState>();
  int normalUsers = 0;
  int merchants = 0;
  int requests = 0;
  int offers = 0;
  bool start = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    if (start) {
      getCount();
      setState(() {
        start = false;
      });
    }
    getTop();
    List dasboarditems = [
      {"title": "Normal users", "value": normalUsers.toString()},
      {"title": "Merchants", "value": merchants.toString()},
      {"title": "Offer Requests", "value": requests.toString()},
      {"title": "Posts", "value": offers.toString()},
    ];
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
                                      user.addCategory([_category.text]);
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(
                                          msg: "Category added");
                                      addCategory.currentState!.reset();
                                      _category.clear();
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
                              builder: (context) => LocalAds(),
                            ),
                          );
                        },
                        title: Text(
                          "Manage Local Ads",
                          style: TextStyle(),
                        ),
                      ),
                    ),Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MCEvents(),
                            ),
                          );
                        },
                        title: Text(
                          "Manage Events",
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
                          "Offers requests",
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
                              builder: (context) => LocalAdsRequests(),
                            ),
                          );
                        },
                        title: Text(
                          "Local Ads requests",
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
                              builder: (context) => EventRequests(),
                            ),
                          );
                        },
                        title: Text(
                          "Event requests",
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
                              title: Text("Add City"),
                              content: Form(
                                key: addPlace,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: _city,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "City name",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: _area,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Area name",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
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
                                    if (addPlace.currentState!.validate()) {
                                      _algoliaApp.instance
                                          .index("cities")
                                          .addObject(<String, dynamic>{
                                        "name": _area.text,
                                        "parent": _city.text,
                                      }).then((value) {
                                        addPlace.currentState!.reset();
                                        _city.clear();
                                        _area.clear();
                                        Fluttertoast.showToast(
                                            msg: "Place added");
                                      });
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
                          "Add cities",
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
                                child: Form(
                                  key: topOffers,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: to[0],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Top 1",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {}
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: to[1],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Top 2",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {}
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: to[2],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Top 3",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {}
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
                                    List temp = [];
                                    for (int i = 0; i < to.length; ++i) {
                                      if (to[i].text.isNotEmpty) {
                                        temp.insert(i, to[i].text);
                                      }
                                    }
                                    user.updateTop(temp, "Offer");
                                    to[0].clear();
                                    to[1].clear();
                                    to[2].clear();
                                    Navigator.pop(context);
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
                                child: Form(
                                  key: topLocalAds,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: tl[0],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Top 1",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {}
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: tl[1],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Top 2",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {}
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: tl[2],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Top 3",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {}
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
                                    List temp = [];
                                    for (int i = 0; i < tl.length; ++i) {
                                      if (tl[i].text.isNotEmpty) {
                                        temp.insert(i, tl[i].text);
                                      }
                                    }
                                    user.updateTop(temp, "Local Ad");
                                    tl[0].clear();
                                    tl[1].clear();
                                    tl[2].clear();
                                    Navigator.pop(context);
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
                                child: Form(
                                  key: topEvents,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: te[0],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Top 1",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {}
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: te[1],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Top 2",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {}
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: te[2],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Top 3",
                                            labelStyle: TextStyle(
                                              color: Color(0xff6DFFF0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {}
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
                                    List temp = [];
                                    for (int i = 0; i < te.length; ++i) {
                                      if (te[i].text.isNotEmpty) {
                                        temp.insert(i, te[i].text);
                                      }
                                    }
                                    user.updateTop(temp, "Event");
                                    te[0].clear();
                                    te[1].clear();
                                    te[2].clear();
                                    Navigator.pop(context);
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

  getTop() async {
    final user = Provider.of<UserProvider>(context);
    var data = await user.getTop("Event");
    if (mounted)
      for (int i = 0; i < data.length; ++i) {
        data[i].get().then((value) {
          setState(() {
            te[i].text = value.data()!["id"];
          });
        });
      }
    data = await user.getTop("Local Ad");
    if (mounted)
      for (int i = 0; i < data.length; ++i) {
        data[i].get().then((value) {
          setState(() {
            tl[i].text = value.data()!["id"];
          });
        });
      }
    data = await user.getTop("Offer");
    if (mounted)
      for (int i = 0; i < data.length; ++i) {
        data[i].get().then((value) {
          setState(() {
            to[i].text = value.data()!["id"];
          });
        });
      }
  }

  getCount() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore.collection("users").get().then((value) {
      if (mounted)
        setState(() {
          normalUsers = value.docs.length;
        });
    });
    _firestore.collection("merchants").get().then((value) {
      if (mounted)
        setState(() {
          merchants = value.docs.length;
        });
    });
    _firestore
        .collection("Offer")
        .where('verified', isEqualTo: "0")
        .get()
        .then((value) {
      if (mounted)
        setState(() {
          requests = value.docs.length;
        });
    });
    _firestore
        .collection("Local Ad")
        .where('verified', isEqualTo: "0")
        .get()
        .then((value) {
      if (mounted)
        setState(() {
          requests = value.docs.length + requests;
        });
    });
    _firestore
        .collection("Event")
        .where('verified', isEqualTo: "0")
        .get()
        .then((value) {
      if (mounted)
        setState(() {
          requests = value.docs.length + requests;
        });
    });
    _firestore.collection("Offer").get().then((value) {
      if (mounted)
        setState(() {
          offers = value.docs.length;
        });
    });
    _firestore.collection("Local Ad").get().then((value) {
      if (mounted)
        setState(() {
          offers = value.docs.length + offers;
        });
    });
    _firestore.collection("Event").get().then((value) {
      if (mounted)
        setState(() {
          offers = value.docs.length + offers;
        });
    });
  }
}
