import 'dart:async';
import 'package:city_offers/cities.dart';
import 'package:city_offers/home.dart';
import 'package:city_offers/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Auth extends StatefulWidget {
  Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
  static String name = "home";
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    if (user.status == Status.Authenticated) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      });
    }
    return Scaffold(
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
                            } else if (await user.signInWithGoogle() == "new") {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamed(Cities.name);
                            } else if (await user.signInWithGoogle() == "old") {
                              Fluttertoast.showToast(msg: "Login successful");
                              Timer(Duration(seconds: 4), () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, Home.name);
                              });
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
              ));
  }
}
