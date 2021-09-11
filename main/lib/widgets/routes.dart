import 'package:main/cities.dart';
import 'package:main/contact.dart';
import 'package:main/Auth.dart';
import 'package:main/profile.dart';
import 'package:main/splash.dart';
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
