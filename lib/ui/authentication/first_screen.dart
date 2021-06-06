import 'package:cool_alert/cool_alert.dart';
import 'package:daily_running/ui/authentication/login/login_screen.dart';
import 'package:daily_running/ui/home/home_screen.dart';
import 'package:daily_running/ui/home/main_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FirstScreen extends StatelessWidget {
  static String id = "FirstScreen";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          }
          return MainScreen();
        } else {
          return Scaffold(
            body: Center(
              child: SpinKitFoldingCube(
                color: kPrimaryColor,
              ),
            ),
          );
        }
      },
    );
  }
}

/*return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          }
          return HomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );*/
