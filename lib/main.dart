import 'package:daily_running/model/login/login_view_model.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/ui/authentication/first_screen.dart';
import 'package:daily_running/ui/authentication/login/login_screen.dart';
import 'package:daily_running/ui/authentication/register/register_update_info_screen.dart';
import 'package:daily_running/ui/home/comment/comment_screen.dart';
import 'package:daily_running/ui/home/home_screen.dart';
import 'package:daily_running/ui/home/main_screen.dart';
import 'package:daily_running/ui/record/finish_record_screen.dart';
import 'package:daily_running/ui/record/record_screen.dart';
import 'package:daily_running/ui/user/follow_detail_screen.dart';
import 'package:daily_running/ui/user/other_user/other_user_activity.dart';
import 'package:daily_running/ui/user/other_user/other_user_screen.dart';
import 'package:daily_running/ui/user/update_info_screen.dart';
import 'package:daily_running/ui/user/user_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'model/home/comment_view_model.dart';
import 'model/home/post_view_model.dart';
import 'model/home/search/search_view_model.dart';
import 'model/login/register_view_model.dart';
import 'model/user/follow_detail_view_model.dart';
import 'model/user/other_user/other_follow_view_model.dart';
import 'model/user/other_user/other_profile_view_model.dart';
import 'model/user/statistic_view_model.dart';
import 'model/user/step_counter_view_model.dart';
import 'model/user/update_info_view_model.dart';
import 'ui/authentication/register/register_screen.dart';
import 'ui/user/gift/gift_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DailyRunning());
}

class DailyRunning extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecordViewModel>(
            create: (context) => RecordViewModel()),
        ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
        ChangeNotifierProvider<RegisterViewModel>(
            create: (context) => RegisterViewModel()),
        ChangeNotifierProvider<UserViewModel>(
            create: (context) => UserViewModel()),
        ChangeNotifierProxyProvider<UserViewModel, UpdateInfoViewModel>(
            create: (context) => UpdateInfoViewModel(),
            update: (context, userViewModel, updateInfoViewModel) =>
                updateInfoViewModel..update(userViewModel)),
        ChangeNotifierProvider<StatisticViewModel>(
            create: (context) => StatisticViewModel()),
        ChangeNotifierProvider<PostViewModel>(
            create: (context) => PostViewModel()),
        ChangeNotifierProvider<SearchViewModel>(
            create: (context) => SearchViewModel()),
        ChangeNotifierProvider<OtherProfileViewModel>(
            create: (context) => OtherProfileViewModel()),
        ChangeNotifierProvider<CommentViewModel>(
            create: (context) => CommentViewModel()),
        ChangeNotifierProvider<StepCounterViewModel>(
            create: (context) => StepCounterViewModel()),
        ChangeNotifierProvider<FollowDetailViewModel>(
            create: (context) => FollowDetailViewModel()),
        ChangeNotifierProxyProvider<OtherProfileViewModel,
                OtherFollowViewModel>(
            create: (context) => OtherFollowViewModel(),
            update: (context, otherProfileViewModel, otherFollowViewModel) =>
                otherFollowViewModel..update(otherProfileViewModel)),
      ],
      child: MaterialApp(
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('vi'), const Locale('en')],
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
          UpdateInfoScreen.id: (context) => UpdateInfoScreen(),
          GiftScreen.id: (context) => GiftScreen(),
          CommentScreen.id: (context) => CommentScreen(),
          OtherUserScreen.id: (context) => OtherUserScreen(),
          OtherUserActivity.id: (context) => OtherUserActivity(),
          FollowDetailScreen.id: (context) => FollowDetailScreen(),
        },
        initialRoute: FirstScreen.id,
      ),
    );
  }
}
