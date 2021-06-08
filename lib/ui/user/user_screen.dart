import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/model/home/navBar/nav_bar_view_model.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/authentication/login/widgets/big_button.dart';
import 'package:daily_running/ui/home/home_screen.dart';
import 'package:daily_running/ui/user/gift/gift_screen.dart';
import 'package:daily_running/ui/user/update_info_screen.dart';
import 'package:daily_running/ui/user/widgets/avatar_view.dart';
import 'package:daily_running/ui/user/widgets/circle_chart.dart';
import 'package:daily_running/ui/user/widgets/medal_item.dart';
import 'package:daily_running/ui/user/widgets/statistic_card.dart';
import 'package:daily_running/ui/user/widgets/user_follow_card.dart';
import 'package:daily_running/ui/user/widgets/user_gift_item.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class UserScreen extends StatelessWidget {
  static String id = 'UserScreen';
  static final List<Widget> achievements = [
    for (int i = 0; i < 10; i++)
      MedalItem(
        image: AssetImage('assets/images/medal_${(i % 5) + 1}.png'),
        onTap: () {},
      ),
  ];

  final List<Widget> statisticTab = [
    SizedBox(
      height: 35,
      child: Tab(
        text: 'Theo tuần',
      ),
    ),
    SizedBox(
      height: 35,
      child: Tab(
        text: 'Theo tháng',
      ),
    ),
    SizedBox(
      height: 35,
      child: Tab(
        text: 'Theo năm',
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    print(RunningRepo.getFirebaseUser().email);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                          image: CachedNetworkImageProvider(
                            Provider.of<UserViewModel>(context)
                                .currentUser
                                .avatarUri,
                          ),
                          onCameraTap: () {
                            //TODO change avatar
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
                          onTap: () => pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: UpdateInfoScreen.id),
                            screen: UpdateInfoScreen(),
                            withNavBar: false,
                          ),
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
                        itemCount: 10,
                        itemBuilder: (context, index) => achievements[index],
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
                      child: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              color: kInActiveTabbarColor,
                              child: TabBar(
                                labelColor: Colors.black,
                                indicator: RectangularIndicator(
                                  color: kActiveTabbarColor,
                                  paintingStyle: PaintingStyle.fill,
                                  topLeftRadius: 18,
                                  topRightRadius: 18,
                                  bottomLeftRadius: 18,
                                  bottomRightRadius: 18,
                                ),
                                tabs: statisticTab,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 110,
                              child: TabBarView(
                                children: [
                                  StatisticCard(
                                    distance: '12Km',
                                    timeWorking: '00:02:20',
                                    workingCount: '5',
                                  ),
                                  StatisticCard(
                                    distance: '24Km',
                                    timeWorking: '00:42:50',
                                    workingCount: '12',
                                  ),
                                  StatisticCard(
                                    distance: '400Km',
                                    timeWorking: '99:99:99',
                                    workingCount: '534',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                screen: GiftScreen(), withNavBar: false);
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
                        onClick: () {
                          //logout click
                          RunningRepo.auth.signOut();
                          RunningRepo.googleSignIn.signOut();
                          RunningRepo.fbAuth.logOut();
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
    );
  }
}
