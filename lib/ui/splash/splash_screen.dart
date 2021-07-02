import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:daily_running/ui/authentication/first_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  static final id = 'SplashScreen';

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
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
    );
  }
}
