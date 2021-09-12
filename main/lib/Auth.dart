import 'package:main/cities.dart';
import 'package:main/profile.dart';
import 'package:main/providers/user_provider.dart';
import 'package:main/widgets/events.dart';
import 'package:main/widgets/local_ads.dart';
import 'package:main/widgets/offers.dart';
import 'package:main/widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'updateCities.dart';

class Auth extends StatefulWidget {
  Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
  static String name = "home";
}

class _AuthState extends State<Auth> {
  List categoriesList = [];
  String? _category;
  int _selectedIndex = 0;
  List offers = [];
  List localAds = [];
  List events = [];
  bool start = true;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    if (start || events.length == 0) {
      getPostsAll();
      getCategories();
      setState(() {
        start = false;
      });
    }
    List<Widget> _widgetOptions = <Widget>[
      Offers(list: offers),
      LocalAds(list: localAds),
      Events(list: events),
    ];
    return user.status == Status.Authenticated
        ? Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {},
                    color: Colors.white,
                    icon: Icon(
                      Icons.share,
                    ),
                  ),
                ),
              ],
              title: Text(
                "My City Offers",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            drawer: Sidebar(),
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Profile.name);
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          color: Colors.black,
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  width: 60,
                                  height: 60,
                                  child: Image.network(
                                    user.userDetails["photoUrl"],
                                  ),
                                ),
                                Text(
                                  user.userDetails["name"].toString().substring(
                                      0,
                                      user.userDetails["name"]
                                          .toString()
                                          .indexOf(" ")),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Expanded(
                        child: DropdownButtonFormField<String>(
                          focusColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Category",
                            hintStyle: TextStyle(
                              color: Colors.orange,
                            ),
                          ),
                          value: _category,
                          elevation: 10,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          items: categoriesList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _category = value!;
                            });
                            getPostsCat();
                            setState(() {
                              _widgetOptions = <Widget>[
                                Offers(list: offers),
                                LocalAds(list: localAds),
                                Events(list: events),
                              ];
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(UpdateCities.name);
                        },
                        child: Container(
                          alignment: Alignment.topRight,
                          color: Colors.black,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    // shadow direction: bottom right
                                  )
                                ],
                              ),
                              height: 40,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  user.userDetails["area"],
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _widgetOptions[_selectedIndex],
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.percent),
                  title: Text('Offers'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.mapMarker),
                  title: Text('Local Ads'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  title: Text('Events'),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber,
              onTap: _onItemTapped,
            ),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Center(
                  child: Text(
                "My City Offers",
                style: TextStyle(color: Colors.white),
              )),
            ),
            body: user.status == Status.Authenticating
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              height: 60,
                              minWidth: 150,
                              onPressed: () async {
                                if (await user.signInWithGoogle() == "fail") {
                                  Fluttertoast.showToast(msg: "Sign in failed");
                                } else if (await user.signInWithGoogle() ==
                                    "new") {
                                  Navigator.pop(context);
                                  Navigator.of(context).pushNamed(Cities.name);
                                } else if (await user.signInWithGoogle() ==
                                    "old") {
                                  Fluttertoast.showToast(
                                      msg: "Login successful");
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.amber,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Icon(
                                      FontAwesomeIcons.google,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    "Login/signup with google",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
  }

  getPostsAll() async {
    final user = Provider.of<UserProvider>(context);
    List data = [];
    user.getPostsAll("Offer", user.userDetails["area"]).then((value) {
      data = value;
      if (mounted)
        setState(() {
          offers = data.where((element) {
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
                .isAfter(DateTime.now());
          }).toList();
        });
    });

    user.getPostsAll("Local Ad.", user.userDetails["area"]).then((value) {
      data = value;
      if (mounted)
        setState(() {
          localAds = data.where((element) {
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
                .isAfter(DateTime.now());
          }).toList();
        });
    });

    user.getPostsAll("Event", user.userDetails["area"]).then((value) {
      data = value;
      if (mounted)
        setState(() {
          events = data.where((element) {
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
                .isAfter(DateTime.now());
          }).toList();
        });
    });
  }

  getPostsCat() {
    setState(() {
      localAds = localAds.where((element) {
        return element.data()["categories"].contains(_category);
      }).toList();
      offers = offers.where((element) {
        return element.data()["categories"].contains(_category);
      }).toList();
      events = events.where((element) {
        return element.data()["categories"].contains(_category);
      }).toList();
    });
  }

  getCategories() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var data = await firestore.collection("categories").get().then((value) {
      return value.docs[0]["list"];
    });
    categoriesList = data;
  }
}
