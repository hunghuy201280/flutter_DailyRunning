import 'package:daily_running/ui/authentication/first_screen.dart';
import 'package:daily_running/ui/authentication/login_screen.dart';
import 'package:daily_running/ui/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
        FirstScreen.id: (context) => FirstScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
      initialRoute: LoginScreen.id,
    );
  }
}
