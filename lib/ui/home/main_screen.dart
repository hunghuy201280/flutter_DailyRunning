import 'package:daily_running/model/home/navBar/nav_bar_view_model.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/authentication/register/register_update_info_screen.dart';
import 'package:daily_running/ui/home/home_screen.dart';
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
  final List<PersistentBottomNavBarItem> navBarItems = [
    PersistentBottomNavBarItem(
      icon: Icon(RunningIcons.ic_home),
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
      title: 'Home',
    ),
    PersistentBottomNavBarItem(
        icon: Icon(
          Icons.add,
          color: Colors.black,
          size: 40,
        ),
        title: 'Record',
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        onPressed: (context) {
          pushNewScreen(context, screen: RecordScreen(), withNavBar: false);
        }),
    PersistentBottomNavBarItem(
      icon: Icon(RunningIcons.profile),
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
      title: 'Profile',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RunningUser>(
      future: RunningRepo.getUser(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          RunningUser currentUser = snapshot.data;
          if (currentUser != null) {
            Provider.of<UserViewModel>(context, listen: false).currentUser =
                currentUser;
            return PersistentTabView(
              context,
              controller: _controller,
              navBarHeight: 60,
              screens: screens,
              items: navBarItems,
              confineInSafeArea: true,
              backgroundColor: Colors.white,
              // Default is Colors.white.
              handleAndroidBackButtonPress: true,
              // Default is true.
              resizeToAvoidBottomInset: true,
              // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true,
              // Default is true.
              hideNavigationBarWhenKeyboardShows: true,
              // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Colors.black,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: ItemAnimationProperties(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimation(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle
                  .style15, // Choose the nav bar style with this property.
            );
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
