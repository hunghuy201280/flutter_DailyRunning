import 'package:daily_running/ui/authentication/login_screen.dart';
import 'package:daily_running/ui/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  static String id = "FirstScreen";

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
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
