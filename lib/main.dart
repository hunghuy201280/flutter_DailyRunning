import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/repository/running_repo.dart';
import 'package:flutter_daily_running_admin/ui/change_password/change_password_screen.dart';
import 'package:flutter_daily_running_admin/ui/gift/gift_screen.dart';
import 'package:flutter_daily_running_admin/ui/login/first_screen.dart';
import 'package:flutter_daily_running_admin/ui/login/forget_password_screen.dart';
import 'package:flutter_daily_running_admin/ui/login/login_screen.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
import 'package:provider/provider.dart';

import 'model/gift/gift_view_model.dart';
import 'model/login/login_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DailyRunningAdmin());
}

class DailyRunningAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>(
            create: (context) => LoginViewModel()),
        ChangeNotifierProvider<GiftViewModel>(
            create: (context) => GiftViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          GiftScreen.id: (context) => GiftScreen(),
          FirstScreen.id: (context) => FirstScreen(),
          ForgetPasswordScreen.id: (context) => ForgetPasswordScreen(),
          ChangePasswordScreen.id: (context) => ChangePasswordScreen(),
        },
        initialRoute: FirstScreen.id,
      ),
    );
  }

  static SnackBar createSnackBar(String text, int duration) {
    return SnackBar(
      duration: Duration(seconds: duration),
      content: Text(
        text,
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  static onLogoutCleanup(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, FirstScreen.id, (route) => false);
    FirebaseAuth.instance.signOut();
  }
}
