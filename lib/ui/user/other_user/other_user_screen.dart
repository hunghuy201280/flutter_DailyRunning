import 'package:daily_running/model/user/other_profile_view_model.dart';
import 'package:daily_running/model/user/other_user/other_profile_view_model.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/ui/user/other_user/other_user_activity.dart';
import 'package:daily_running/ui/user/other_user/widgets/other_user_follow_card.dart';
import 'package:daily_running/ui/user/other_user/widgets/other_user_statistic_widget.dart';
import 'package:daily_running/ui/user/user_screen.dart';
import 'package:daily_running/ui/user/widgets/avatar_view.dart';
import 'package:daily_running/ui/user/widgets/user_follow_card.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class OtherUserScreen extends StatelessWidget {
  static final id = 'OtherUserScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<bool>(
          future: Provider.of<OtherProfileViewModel>(context).loadingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data == false) {
              return Consumer<OtherProfileViewModel>(
                builder: (context, otherViewModel, _) => SingleChildScrollView(
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
                                  imageUrl:
                                      otherViewModel.selectedUser.avatarUri,
                                  onCameraTap: () {},
                                  canChangeAvatar: false,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            child: kAppNameTextWhite,
                            alignment: Alignment.topCenter,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkResponse(
                                  onTap: () => Navigator.pop(context),
                                  radius: 16,
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        otherViewModel.selectedUser.displayName,
                        style: kTitleTextStyle.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        child: OtherUserFollowCard(),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Provider.of<OtherProfileViewModel>(context,
                                  listen: false)
                              .onFollowClick();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(200, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: otherViewModel.isFollowed
                                ? BorderSide(width: 1, color: Colors.grey)
                                : BorderSide.none,
                          ),
                          backgroundColor: otherViewModel.isFollowed
                              ? Colors.white
                              : kActiveTabbarColor,
                        ),
                        child: Text(
                          otherViewModel.isFollowed
                              ? 'HỦY THEO DÕI'
                              : 'THEO DÕI',
                          style: kTitleTextStyle.copyWith(
                              color: otherViewModel.isFollowed
                                  ? kActiveTabbarColor
                                  : Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/ic_running_point.png',
                          height: 50,
                        ),
                      ),
                      Text(
                        otherViewModel.selectedUser.point.toString(),
                        style: kBigTitleTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 10),
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
                                itemBuilder: (context, index) =>
                                    UserScreen.achievements[index],
                                separatorBuilder: (context, index) => SizedBox(
                                  width: 40,
                                ),
                              ),
                            ),
                            Text(
                              'Thống kê',
                              style: kBigTitleTextStyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: OtherUserStatisticWidget(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hoạt động',
                                      style: kBigTitleTextStyle,
                                    ),
                                    Text(
                                      '${otherViewModel.userActivities.length} hoạt động',
                                      style: kSmallTitleTextStyle.copyWith(
                                          color: kDoveGrayColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    //todo show all activity
                                    Navigator.pushNamed(
                                        context, OtherUserActivity.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
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
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else
              return Center(
                child: SpinKitCubeGrid(
                  color: kPrimaryColor,
                ),
              );
          },
        ),
      ),
    );
  }
}
