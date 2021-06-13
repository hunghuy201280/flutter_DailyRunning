import 'package:daily_running/ui/record/record_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:daily_running/utils/running_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

List<PersistentBottomNavBarItem> getNavBarItems(BuildContext mContext) => [
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
            pushNewScreen(mContext, screen: RecordScreen(), withNavBar: false);
          }),
      PersistentBottomNavBarItem(
        icon: Icon(RunningIcons.profile),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        title: 'Profile',
      ),
    ];

class MyPersistentTabView extends StatelessWidget {
  const MyPersistentTabView({
    Key key,
    @required PersistentTabController controller,
    @required this.screens,
    @required this.navBarItems,
  })  : _controller = controller,
        super(key: key);

  final PersistentTabController _controller;
  final List<Widget> screens;
  final List<PersistentBottomNavBarItem> navBarItems;

  @override
  Widget build(BuildContext context) {
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
      navBarStyle:
          NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }
}
