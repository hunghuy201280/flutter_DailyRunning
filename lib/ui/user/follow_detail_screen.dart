import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/model/user/follow_detail_view_model.dart';
import 'package:daily_running/model/user/other_user/other_profile_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'other_user/other_user_screen.dart';

class FollowDetailScreen extends StatelessWidget {
  static String id = "FollowDetailScreen";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            Provider.of<FollowDetailViewModel>(context).title,
            style: kBigTitleTextStyle,
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<FollowDetailViewModel>(context).isLoading,
          progressIndicator: Center(
            child: SpinKitFoldingCube(
              color: kPrimaryColor,
              size: 50,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListView.builder(
                itemCount:
                    Provider.of<FollowDetailViewModel>(context).data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        if (Provider.of<FollowDetailViewModel>(context,
                                    listen: false)
                                .data[index]
                                .userID ==
                            RunningRepo.auth.currentUser.uid) return;
                        Provider.of<OtherProfileViewModel>(context,
                                listen: false)
                            .onUserSelected(Provider.of<FollowDetailViewModel>(
                                    context,
                                    listen: false)
                                .data[index]
                                .userID);
                        pushNewScreen(
                          context,
                          screen: OtherUserScreen(),
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                          withNavBar: false,
                        );
                      },
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: Provider.of<FollowDetailViewModel>(
                                    context,
                                    listen: false)
                                .data[index]
                                .avatarUri,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 24,
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                              child: CircleAvatar(
                                radius: 24,
                              ),
                              baseColor: kSecondaryColor,
                              highlightColor: Colors.grey[100],
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            Provider.of<FollowDetailViewModel>(context,
                                    listen: false)
                                .data[index]
                                .displayName,
                            style: kRoboto500TextStyle.copyWith(
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
