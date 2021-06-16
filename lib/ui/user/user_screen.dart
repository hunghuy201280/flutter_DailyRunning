import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/model/home/post_view_model.dart';
import 'package:daily_running/model/home/search/search_view_model.dart';
import 'package:daily_running/model/login/login_view_model.dart';
import 'package:daily_running/model/login/register_view_model.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/user/statistic_view_model.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/authentication/login/widgets/big_button.dart';
import 'package:daily_running/ui/home/home_screen.dart';
import 'package:daily_running/ui/user/gift/gift_screen.dart';
import 'package:daily_running/ui/user/update_info_screen.dart';
import 'package:daily_running/ui/user/widgets/avatar_view.dart';
import 'package:daily_running/ui/user/widgets/blur_loading.dart';
import 'package:daily_running/ui/user/widgets/change_avatar_dialog.dart';
import 'package:daily_running/ui/user/widgets/circle_chart.dart';
import 'package:daily_running/ui/user/widgets/medal_item.dart';
import 'package:daily_running/ui/user/widgets/statistic_card.dart';
import 'package:daily_running/ui/user/widgets/statistic_widget.dart';
import 'package:daily_running/ui/user/widgets/user_follow_card.dart';
import 'package:daily_running/ui/user/widgets/user_gift_item.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class UserScreen extends StatelessWidget {
  static String id = 'UserScreen';

  void onLogOutCleanUp(BuildContext context) {
    Provider.of<PostViewModel>(context, listen: false).resetData();
    Provider.of<LoginViewModel>(context, listen: false).reset();
    Provider.of<RegisterViewModel>(context, listen: false).reset();
    Provider.of<RecordViewModel>(context, listen: false).resetData();
    Provider.of<StatisticViewModel>(context, listen: false).resetData();
    Provider.of<SearchViewModel>(context, listen: false).resetData();
    RunningRepo.auth.signOut();
    RunningRepo.googleSignIn.signOut();
    RunningRepo.fbAuth.logOut();
  }

  @override
  Widget build(BuildContext context) {
    print(RunningRepo.getFirebaseUser().email);
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<UserViewModel>(context).isLoading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset('assets/images/user_banner.png'),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.white,
                              width: 6.0,
                            ),
                          ),
                          child: AvatarView(
                            //image: AssetImage('assets/images/drip_doge.png'),
                            imageUrl: Provider.of<UserViewModel>(context)
                                .currentUser
                                .avatarUri,
                            onCameraTap: () async {
                              //TODO change avatar
                              ImageSource source = await showDialog(
                                context: context,
                                builder: (context) => ChangeAvatarDialog(),
                              );
                              if (source == null) return;
                              Provider.of<UserViewModel>(context, listen: false)
                                  .onAvatarChange(source);
                            },
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkResponse(
                            onTap: () => pushNewScreenWithRouteSettings(context,
                                settings:
                                    RouteSettings(name: UpdateInfoScreen.id),
                                screen: UpdateInfoScreen(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino),
                            radius: 16,
                            child: SvgPicture.asset(
                              'assets/images/ic_setting.svg',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      child: kAppNameTextWhite,
                      alignment: Alignment.topCenter,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  Provider.of<UserViewModel>(context).currentUser.displayName,
                  style: kTitleTextStyle.copyWith(
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  child: UserFollowCard(),
                ),
                Image.asset(
                  'assets/images/ic_running_point.png',
                  height: 50,
                ),
                Text(
                  Provider.of<UserViewModel>(context)
                      .currentUser
                      .point
                      .toString(),
                  style: kBigTitleTextStyle,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Huy hiệu',
                        style: kBigTitleTextStyle,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 60,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: Provider.of<StatisticViewModel>(context)
                              .medals
                              .length,
                          itemBuilder: (context, index) =>
                              Provider.of<StatisticViewModel>(context)
                                  .medals[index],
                          separatorBuilder: (context, index) => SizedBox(
                            width: 40,
                          ),
                        ),
                      ),
                      Text(
                        'Mục tiêu hằng ngày',
                        style: kBigTitleTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: CircleChart(
                          val: 7000,
                          percent: 0.7,
                        ),
                      ),
                      Text(
                        'Thống kê',
                        style: kBigTitleTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: StatisticWidget(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Đổi quà',
                            style: kBigTitleTextStyle,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              //TODO on all gift click
                              pushNewScreen(context,
                                  screen: GiftScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              primary: kConcreteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              'XEM TẤT CẢ',
                              style: kTitleTextStyle.copyWith(
                                color: kActiveTabbarColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox.fromSize(
                        size: Size(double.infinity, 200),
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => UserGiftItem(
                                  image: AssetImage(
                                    'assets/images/login_banner.jpg',
                                  ),
                                  providerName:
                                      'Tên nhà cung cấp.........Tên nhà cung cấp.........',
                                  giftDetail: 'Chi tiết ưu đãiChi tiết ưu đãi',
                                  point: 200,
                                ),
                            separatorBuilder: (context, index) => SizedBox(
                                  width: 30,
                                ),
                            itemCount: 10),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      BigButton(
                          text: 'Đăng xuất',
                          onClick: () async {
                            //logout click
                            onLogOutCleanUp(context);
                          },
                          horizontalPadding: 20),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
