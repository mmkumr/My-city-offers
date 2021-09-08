import 'package:city_offers/cities.dart';
import 'package:city_offers/providers/user_provider.dart';
import 'package:city_offers/widgets/events.dart';
import 'package:city_offers/widgets/local_ads.dart';
import 'package:city_offers/widgets/offers.dart';
import 'package:city_offers/widgets/sidebar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
  static String name = "home";
}

class _HomeState extends State<Home> {
  String? _chosenValue;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Offers(),
    LocalAds(),
    Events(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  initState() {
    super.initState();
    firebaseinit();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
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
                          user.userDetails["name"].toString().substring(0,
                              user.userDetails["name"].toString().indexOf(" ")),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
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
                  value: _chosenValue,
                  elevation: 10,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  items: <String>["Hotels", 'Restaurants', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _chosenValue = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Cities.name);
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
                            style: TextStyle(fontSize: 15, color: Colors.white),
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
    );
  }

  void firebaseinit() async {
    await Firebase.initializeApp();
  }
}
