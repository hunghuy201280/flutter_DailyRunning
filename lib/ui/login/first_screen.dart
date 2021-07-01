import 'package:cool_alert/cool_alert.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/model/login/login_view_model.dart';
import 'package:flutter_daily_running_admin/ui/gift/gift_screen.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class FirstScreen extends StatelessWidget {
  static String id = "FirstScreen";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          Provider.of<LoginViewModel>(context, listen: false).reset();
          if (user == null) {
            print("login");
            return LoginScreen();
          }
          print("gift");
          return GiftScreen();
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
