import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/ui/login/first_screen.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';

class SplashScreen extends StatelessWidget {
  static final id = 'SplashScreen';

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        "assets/images/app_icon.png",
        height: 100,
      ),
      backgroundColor: kPrimaryColor,
      splashTransition: SplashTransition.slideTransition,
      nextScreen: FirstScreen(),
    );
  }
}
