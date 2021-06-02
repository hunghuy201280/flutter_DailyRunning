import 'package:daily_running/ui/authentication/first_screen.dart';
import 'package:daily_running/ui/authentication/login/login_screen.dart';
import 'package:daily_running/ui/authentication/register/register_update_info_screen.dart';
import 'package:daily_running/ui/home/home_screen.dart';
import 'package:daily_running/ui/home/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'ui/authentication/register/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DailyRunning());
}

class DailyRunning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        RegisterUpdateInfo.id: (context) => RegisterUpdateInfo(),
        RegisterScreen.id: (context) => RegisterScreen(),
        FirstScreen.id: (context) => FirstScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        MainScreen.id: (context) => MainScreen(),
      },
      initialRoute: HomeScreen.id,
    );
  }
}
