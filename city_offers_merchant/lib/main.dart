import 'package:city_offers_merchant/add_items.dart';
import 'package:city_offers_merchant/cities.dart';
import 'package:city_offers_merchant/expired_items.dart';
import 'package:city_offers_merchant/manage_items.dart';
import 'package:city_offers_merchant/profile.dart';
import 'package:city_offers_merchant/providers/user_provider.dart';
import 'package:city_offers_merchant/signup.dart';
import 'package:city_offers_merchant/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider.initialize(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Splash.name,
        theme: ThemeData(primarySwatch: Colors.amber),
        home: ScreensController(),
      ),
    ),
  );
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch (user.status) {
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
        return Auth();
      case Status.Authenticating:
      case Status.Authenticated:
        return Auth();
    }
  }
}

class Auth extends StatefulWidget {
  Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return user.status == Status.Unauthenticated
        ? Scaffold(
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Signup(),
                                    ),
                                  );
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Login/signup with\ngoogle(business email)",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
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
          )
        : DefaultTabController(
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
                      text: "Manage items",
                    ),
                    Tab(
                      icon: Icon(Icons.contact_phone_rounded),
                      text: "Contack us",
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 30,
                      ),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.white,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Profile(),
                                    ),
                                  );
                                },
                                title: Text("My profile"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.white,
                              child: ListTile(
                                onTap: () {
                                  user.signOut();
                                },
                                title: Text("Logout"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.white,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Cities(),
                                    ),
                                  );
                                },
                                title: Text("Add item"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.white,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ManageItems(),
                                    ),
                                  );
                                },
                                title: Text("Manage items"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.white,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ExpiredItems(),
                                    ),
                                  );
                                },
                                title: Text("Expired items"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You can show your offer/events/local ads on the top by contacting us. Only 3 agency's offer/events/local can be pinned on the top for a specific period. So, hurry up!",
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    color: Colors.amber,
                                    onPressed: () {
                                      launch("tel:214324234");
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Call us",
                                          softWrap: true,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    color: Colors.amber,
                                    onPressed: () {
                                      launch(
                                          "mailto:demo@gmail.com?subject=Mechant Query.");
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.mail,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Email us",
                                          softWrap: true,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
