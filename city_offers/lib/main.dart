import 'package:city_offers/Auth.dart';
import 'package:city_offers/cities.dart';
import 'package:city_offers/home.dart';
import 'package:city_offers/providers/user_provider.dart';
import 'package:city_offers/splash.dart';
import 'package:city_offers/widgets/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider.initialize(),
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        initialRoute: Splash.name,
        routes: MyRoute.names,
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
    print(user.status);
    switch (user.status) {
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
        return Auth();
      case Status.Authenticating:
        return Cities();
      case Status.Authenticated:
        return Home();
    }
  }

}
