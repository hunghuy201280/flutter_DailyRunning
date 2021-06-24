import 'package:daily_running/model/user/follow_detail_view_model.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../follow_detail_screen.dart';

class UserFollowCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(width: 1, color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: IntrinsicHeight(
          child: Consumer<UserViewModel>(
            builder: (context, viewModel, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Provider.of<FollowDetailViewModel>(context, listen: false)
                        .onUserSelected("Người theo dõi", viewModel.follower);
                    pushNewScreen(context,
                        screen: FollowDetailScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  },
                  child: UserFollowNumColumn(
                    value: viewModel.follower.length,
                    title: 'Người theo dõi',
                  ),
                ),
                VerticalDivider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<FollowDetailViewModel>(context, listen: false)
                        .onUserSelected("Đang theo dõi", viewModel.following);
                    pushNewScreen(context,
                        screen: FollowDetailScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  },
                  child: UserFollowNumColumn(
                    value: viewModel.following.length,
                    title: 'Đang theo dõi',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserFollowNumColumn extends StatelessWidget {
  final int value;
  final String title;

  const UserFollowNumColumn({@required this.value, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: kBigTitleTextStyle.copyWith(fontSize: 22),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: kPostTextStyle.copyWith(fontSize: 15),
        ),
      ],
    );
  }
}
