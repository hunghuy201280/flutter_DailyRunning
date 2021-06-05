import 'package:daily_running/model/home/navBar/nav_bar_view_model.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/ui/authentication/first_screen.dart';
import 'package:daily_running/ui/authentication/login/login_screen.dart';
import 'package:daily_running/ui/authentication/register/register_update_info_screen.dart';
import 'package:daily_running/ui/home/home_screen.dart';
import 'package:daily_running/ui/home/main_screen.dart';
import 'package:daily_running/ui/record/finish_record_screen.dart';
import 'package:daily_running/ui/record/record_screen.dart';
import 'package:daily_running/ui/user/user_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/authentication/register/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DailyRunning());
}

class DailyRunning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavBarViewModel>(
            create: (context) => NavBarViewModel()),
        ChangeNotifierProvider<RecordViewModel>(
            create: (context) => RecordViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          RegisterUpdateInfo.id: (context) => RegisterUpdateInfo(),
          RegisterScreen.id: (context) => RegisterScreen(),
          FirstScreen.id: (context) => FirstScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          MainScreen.id: (context) => MainScreen(),
          UserScreen.id: (context) => UserScreen(),
          RecordScreen.id: (context) => RecordScreen(),
          FinishRecordScreen.id: (context) => FinishRecordScreen(),
        },
        initialRoute: FinishRecordScreen.id,
      ),
    );
  }
}
