import 'package:main/Auth.dart';
import 'package:main/cities.dart';
import 'package:main/providers/user_provider.dart';
import 'package:main/splash.dart';
import 'package:main/widgets/routes.dart';
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
        return Auth();
    }
  }
}
