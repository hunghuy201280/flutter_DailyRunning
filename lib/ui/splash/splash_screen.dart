import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:daily_running/ui/authentication/first_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  static final id = 'SplashScreen';

  SharedPreferences prefs;
  Future<bool> checkLaunch() async {
    prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = (prefs.getBool('isFirstLaunch') ?? true);
    return isFirstLaunch;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      builder: (context, snapshot) {
        print("${snapshot.connectionState} ${snapshot.hasData}");
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data) {
            prefs.setBool('isFirstLaunch', false);
            return OnboardingScreen();
          } else
            return FirstScreen();
        } else
          return Center(
            child: SpinKitCircle(
              color: kPrimaryColor,
              size: 50,
            ),
          );
      },
      future: checkLaunch(),
    );

    /* AnimatedSplashScreen.withScreenFunction(
      splash: Image.asset(
        "assets/images/app_icon.png",
        height: 100,
      ),
      backgroundColor: kPrimaryColor,
      splashTransition: SplashTransition.slideTransition,
      screenFunction: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isFirstLaunch = (prefs.getBool('isFirstLaunch') ?? true);
        if (isFirstLaunch) {
          await prefs.setBool('isFirstLaunch', false);
          return OnboardingScreen();
        } else {
          return FirstScreen();
        }
      },
    );*/
  }
}
