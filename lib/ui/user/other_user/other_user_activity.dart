import 'package:daily_running/model/user/other_profile_view_model.dart';
import 'package:daily_running/model/user/other_user/other_profile_view_model.dart';
import 'package:daily_running/ui/home/widgets/other_profile_post_view.dart';
import 'package:daily_running/ui/home/widgets/post_view.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherUserActivity extends StatelessWidget {
  static final id = 'OtherUserActivity';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Hoạt động',
            style: kBigTitleTextStyle,
          ),
          backgroundColor: kPrimaryColor,
        ),
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemBuilder: (context, index) {
            return OtherProfilePostView(
              index: index,
            );
          },
          itemCount:
              Provider.of<OtherProfileViewModel>(context).userActivities.length,
        ),
      ),
    );
  }
}
