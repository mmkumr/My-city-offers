import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:city_offers/Auth.dart';
import 'package:city_offers/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
  static String name = "splash";
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    super.initState();
    firebaseinit();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: AnimatedSplashScreen(
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset(
                "assets/img/logo.png",
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ),
            Text("My City Offers",
                style: GoogleFonts.lobster(
                  color: Color(0xffffd700),
                  fontSize: 20,
                )),
          ],
        ),
        backgroundColor: Colors.black,
        splashTransition: SplashTransition.scaleTransition,
        splashIconSize: MediaQuery.of(context).size.height * 0.5,
        duration: 4000,
        nextScreen: Auth(),
      ),
    );
  }

  void firebaseinit() async {
    await Firebase.initializeApp();
  }
}
