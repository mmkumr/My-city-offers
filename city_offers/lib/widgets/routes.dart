import 'package:city_offers/cities.dart';
import 'package:city_offers/contact.dart';
import 'package:city_offers/Auth.dart';
import 'package:city_offers/profile.dart';
import 'package:city_offers/signup.dart';
import 'package:city_offers/splash.dart';
import 'package:flutter/material.dart';

class MyRoute {
  static Map<String, WidgetBuilder> names = <String, WidgetBuilder>{
    Splash.name: (context) => Splash(),
    Auth.name: (context) => Auth(),
    Cities.name: (context) => Cities(),
    Contact.name: (context) => Contact(),
    Profile.name: (context) => Profile()
  };
}
