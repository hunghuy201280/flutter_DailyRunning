import 'package:daily_running/model/user/other_user/other_follow_view_model.dart';
import 'package:daily_running/ui/user/widgets/user_follow_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherUserFollowCard extends StatelessWidget {
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
          child: Consumer<OtherFollowViewModel>(
            builder: (context, viewModel, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    //todo show follower
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
                    //todo show following
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
