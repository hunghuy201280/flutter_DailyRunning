import 'package:daily_running/model/home/post_view_model.dart';
import 'package:daily_running/model/home/search/search_view_model.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/model/user/statistic_view_model.dart';
import 'package:daily_running/model/user/update_info_view_model.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/authentication/register/register_update_info_screen.dart';
import 'package:daily_running/ui/home/home_screen.dart';
import 'package:daily_running/ui/home/widgets/nav_view.dart';
import 'package:daily_running/ui/record/record_screen.dart';
import 'package:daily_running/ui/user/user_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:daily_running/utils/running_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  static String id = 'MainScreen';
  final _controller = PersistentTabController(initialIndex: 0);
  final List<Widget> screens = [HomeScreen(), RecordScreen(), UserScreen()];

  void initLoading(BuildContext context, RunningUser currentUser) {
    Provider.of<UserViewModel>(context, listen: false)
        .setCurrentUserNoNotify(currentUser);
    Provider.of<UpdateInfoViewModel>(context, listen: false)
        .setUpdateUser(currentUser);
    Provider.of<StatisticViewModel>(context, listen: false).getStatistic();
    Provider.of<PostViewModel>(context, listen: false).getMyPost();
    Provider.of<SearchViewModel>(context, listen: false).getSearchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RunningUser>(
      future: RunningRepo.getUser(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        print('mainscreen_getuser get called');
        if (snapshot.connectionState == ConnectionState.done) {
          RunningUser currentUser = snapshot.data;
          if (currentUser != null) {
            initLoading(context, currentUser);
            return MyPersistentTabView(
                controller: _controller,
                screens: screens,
                navBarItems: getNavBarItems(context));
          } else {
            return RegisterUpdateInfo(isEmail: false);
          }
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SpinKitChasingDots(
                color: kPrimaryColor,
              ),
            ),
          );
        }
      },
    );
  }
}
