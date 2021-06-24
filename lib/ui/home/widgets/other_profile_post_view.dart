import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/model/home/comment_view_model.dart';
import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/model/home/post_view_model.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/user/other_user/other_profile_view_model.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/home/comment/comment_screen.dart';
import 'package:daily_running/ui/home/widgets/post_view.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OtherProfilePostView extends StatelessWidget {
  final int index;
  final bool isLoading;
  const OtherProfilePostView({
    this.isLoading = false,
    @required this.index,
  });
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24, horizontal: 25),
      padding: EdgeInsets.only(top: 8, bottom: 16, right: 24, left: 24),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kConcreteColor,
      ),
      child: Consumer<OtherProfileViewModel>(
        builder: (context, otherProfileViewModel, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                isLoading
                    ? Shimmer.fromColors(
                        baseColor: kSecondaryColor,
                        highlightColor: Colors.grey[100],
                        child: CircleAvatar(
                          radius: 22,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            otherProfileViewModel.posts[index].ownerAvatarUrl,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 22,
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => Shimmer.fromColors(
                          child: CircleAvatar(
                            radius: 22,
                          ),
                          baseColor: kSecondaryColor,
                          highlightColor: Colors.grey[100],
                        ),
                      ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading
                        ? Shimmer.fromColors(
                            baseColor: kSecondaryColor,
                            highlightColor: Colors.grey[100],
                            child: Container(
                              width: 70,
                              height: 15,
                              color: kSecondaryColor,
                            ),
                          )
                        : Text(
                            otherProfileViewModel.posts[index].ownerName,
                            style: kPostTextStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                    isLoading
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Shimmer.fromColors(
                              baseColor: kSecondaryColor,
                              highlightColor: Colors.grey[100],
                              child: Container(
                                width: 100,
                                height: 15,
                                color: kSecondaryColor,
                              ),
                            ),
                          )
                        : Text(
                            otherProfileViewModel
                                .posts[index].activity.dateCreated,
                            style: kPostTextStyle,
                          ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            isLoading
                ? Shimmer.fromColors(
                    baseColor: kSecondaryColor,
                    highlightColor: Colors.grey[100],
                    child: Container(
                      height: 30,
                      color: kSecondaryColor,
                    ),
                  )
                : Text(
                    otherProfileViewModel.posts[index].activity.describe ?? "",
                    style: kPostTextStyle.copyWith(fontSize: 16),
                  ),
            Divider(
              color: kDividerColor,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PostColumnText(
                  value:
                      '${isLoading ? 0 : (otherProfileViewModel.posts[index].activity.distance / 1000).toStringAsFixed(2)}Km',
                  description: 'Quãng đường',
                  isLoading: isLoading,
                ),
                PostColumnText(
                  value:
                      '${isLoading ? 0 : PostView.getTimeWorkingInMinute(otherProfileViewModel.posts[index].activity.duration)} phút',
                  description: 'Thời gian',
                  isLoading: isLoading,
                ),
                PostColumnText(
                  value:
                      '${(isLoading ? 0 : otherProfileViewModel.posts[index].activity.pace * 60).toStringAsFixed(2)} m/ph',
                  description: 'Tốc độ',
                  isLoading: isLoading,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            isLoading
                ? Shimmer.fromColors(
                    baseColor: kSecondaryColor,
                    highlightColor: Colors.grey[100],
                    child: Container(
                      height: 180,
                      color: kSecondaryColor,
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl:
                        otherProfileViewModel.posts[index].activity.pictureURI,
                    imageBuilder: (context, imageProvider) => SizedBox.fromSize(
                      size: Size(double.infinity, 180),
                      child: GestureDetector(
                        onTap: () => Provider.of<OtherProfileViewModel>(context,
                                listen: false)
                            .onActivitySelected(context, index),
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: kSecondaryColor,
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: 180,
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                PostBottomIcon(
                  iconName: index == -1
                      ? 'assets/images/ic_heart.svg'
                      : 'assets/images/ic_heart${otherProfileViewModel.isLiked[index] ? '_filled' : ''}.svg',
                  value: index == -1
                      ? '0'
                      : otherProfileViewModel.posts[index].likeUserID.length
                          .toString(),
                  isLoading: isLoading,
                  onTap: () {
                    //TODO on like tap
                    Provider.of<OtherProfileViewModel>(context, listen: false)
                        .toggleLike(index);
                  },
                ),
                SizedBox(
                  width: 22,
                ),
                PostBottomIcon(
                  iconName: 'assets/images/ic_comment.svg',
                  value: index == -1
                      ? '0'
                      : otherProfileViewModel.posts[index].comment.length
                          .toString(),
                  isLoading: isLoading,
                  onTap: () {
                    //TODO on cmt tap
                    Provider.of<CommentViewModel>(context, listen: false)
                        .onPostSelected(otherProfileViewModel.posts[index]);
                    pushNewScreen(context,
                        screen: CommentScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PostBottomIcon extends StatelessWidget {
  final String iconName;
  final String value;
  final bool isLoading;
  final void Function() onTap;
  const PostBottomIcon({
    @required this.iconName,
    @required this.value,
    this.isLoading = false,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            baseColor: kSecondaryColor,
            highlightColor: Colors.grey[100],
            child: Container(
              width: 20,
              height: 15,
              color: kSecondaryColor,
            ),
          )
        : Row(
            children: [
              InkWell(
                child: SvgPicture.asset(
                  iconName,
                  height: 13,
                ),
                onTap: onTap,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                value,
                style: kPostTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: kDividerColor,
                ),
              )
            ],
          );
  }
}
