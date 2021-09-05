import 'package:city_offers/signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Auth extends StatefulWidget {
  Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
  static String name = "home";
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Center(
              child: Text(
            "My City Offers",
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  height: 60,
                  minWidth: 150,
                  onPressed: () {
                    Navigator.pushNamed(context, Signup.name);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.amber,
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  height: 60,
                  minWidth: 150,
                  onPressed: () {},
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
                        "Login with google",
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
        ));
  }
}
