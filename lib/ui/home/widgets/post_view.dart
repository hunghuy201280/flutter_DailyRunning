import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/model/home/comment_view_model.dart';
import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/model/home/post_view_model.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/user/follow_detail_view_model.dart';
import 'package:daily_running/model/user/other_user/other_profile_view_model.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/home/comment/comment_screen.dart';
import 'package:daily_running/ui/user/follow_detail_screen.dart';
import 'package:daily_running/ui/user/other_user/other_user_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostView extends StatelessWidget {
  static String getTimeWorkingInMinute(int timeWorkingInSec) {
    return '${(timeWorkingInSec.toDouble() / 60).toStringAsFixed(2)}';
  }

  final int index;
  final bool isLoading;
  final PostType type;
  const PostView({
    this.isLoading = false,
    @required this.index,
    @required this.type,
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
      child: Consumer<PostViewModel>(
        builder: (context, postViewModel, _) => Column(
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
                    : GestureDetector(
                        onTap: () {
                          if (type == PostType.Following) {
                            Provider.of<OtherProfileViewModel>(context,
                                    listen: false)
                                .onUserSelected(postViewModel
                                    .followingPosts[index].ownerID);
                            pushNewScreen(
                              context,
                              screen: OtherUserScreen(),
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                              withNavBar: false,
                            );
                          }
                        },
                        child: CachedNetworkImage(
                          imageUrl: type == PostType.Me
                              ? postViewModel.myPosts[index].ownerAvatarUrl
                              : postViewModel
                                  .followingPosts[index].ownerAvatarUrl,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
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
                        : GestureDetector(
                            onTap: () {
                              if (type == PostType.Following) {
                                Provider.of<OtherProfileViewModel>(context,
                                        listen: false)
                                    .onUserSelected(postViewModel
                                        .followingPosts[index].ownerID);
                                pushNewScreen(
                                  context,
                                  screen: OtherUserScreen(),
                                  withNavBar: false,
                                );
                              }
                            },
                            child: Text(
                              type == PostType.Me
                                  ? postViewModel.myPosts[index].ownerName
                                  : postViewModel
                                      .followingPosts[index].ownerName,
                              style: kPostTextStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
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
                            type == PostType.Me
                                ? postViewModel
                                    .myPosts[index].activity.dateCreated
                                : postViewModel
                                    .followingPosts[index].activity.dateCreated,
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
                    type == PostType.Me
                        ? postViewModel.myPosts[index].activity.describe
                        : postViewModel
                                .followingPosts[index].activity.describe ??
                            "",
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
                      '${isLoading ? 0 : (type == PostType.Me ? postViewModel.myPosts[index].activity.distance / 1000 : postViewModel.followingPosts[index].activity.distance / 1000).toStringAsFixed(2)}Km',
                  description: 'Quãng đường',
                  isLoading: isLoading,
                ),
                PostColumnText(
                  value:
                      '${isLoading ? 0 : PostView.getTimeWorkingInMinute(type == PostType.Me ? postViewModel.myPosts[index].activity.duration : postViewModel.followingPosts[index].activity.duration)} phút',
                  description: 'Thời gian',
                  isLoading: isLoading,
                ),
                PostColumnText(
                  value:
                      '${(isLoading ? 0 : (type == PostType.Me ? postViewModel.myPosts[index].activity.pace : postViewModel.followingPosts[index].activity.pace) * 60).toStringAsFixed(2)} m/ph',
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
                    imageUrl: type == PostType.Me
                        ? postViewModel.myPosts[index].activity.pictureURI
                        : postViewModel
                            .followingPosts[index].activity.pictureURI,
                    imageBuilder: (context, imageProvider) => SizedBox.fromSize(
                      size: Size(double.infinity, 180),
                      child: GestureDetector(
                        onTap: () =>
                            Provider.of<PostViewModel>(context, listen: false)
                                .onActivitySelected(context, index, type),
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
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
                /* PostBottomIcon(
                  iconName: index == -1
                      ? 'assets/images/ic_heart.svg'
                      : 'assets/images/ic_heart${(type == PostType.Me ? postViewModel.isLikedMyPost[index] : postViewModel.isLikedFollowingPost[index]) ? '_filled' : ''}.svg',
                  value: index == -1
                      ? '0'
                      : type == PostType.Me
                          ? postViewModel.myPosts[index].likeUserID.length
                              .toString()
                          : postViewModel
                              .followingPosts[index].likeUserID.length
                              .toString(),
                  isLoading: isLoading,
                  onTap: () {
                    //TODO on like tap
                    Provider.of<PostViewModel>(context, listen: false)
                        .toggleLike(index, type);
                  },
                ),*/
                GestureDetector(
                  onLongPress: () {
                    Provider.of<FollowDetailViewModel>(context, listen: false)
                        .onPostSelected(type == PostType.Me
                            ? postViewModel.myPosts[index]
                            : postViewModel.followingPosts[index]);
                    pushNewScreen(context,
                        screen: FollowDetailScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  },
                  child: LikeButton(
                    likeCount: index == -1
                        ? 0
                        : type == PostType.Me
                            ? postViewModel.myPosts[index].likeUserID.length
                            : postViewModel
                                .followingPosts[index].likeUserID.length,
                    circleColor:
                        CircleColor(start: Colors.yellow, end: Colors.blue),
                    likeBuilder: (isLiked) {
                      return Icon(
                        isLiked
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: isLiked ? kPrimaryColor : kDividerColor,
                      );
                    },
                    countBuilder: (int count, bool isLiked, String text) {
                      var color = isLiked ? kPrimaryColor : kDividerColor;
                      Widget result;
                      result = Text(
                        text,
                        style: kPostTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      );
                      return result;
                    },
                    isLiked: index == -1
                        ? false
                        : (type == PostType.Me
                            ? postViewModel.isLikedMyPost[index]
                            : postViewModel.isLikedFollowingPost[index]),
                    onTap: (isLike) async {
                      Provider.of<PostViewModel>(context, listen: false)
                          .toggleLike(index, type);
                      return !isLike;
                    },
                  ),
                ),
                SizedBox(
                  width: 22,
                ),
                PostBottomIcon(
                  iconName: 'assets/images/ic_comment.svg',
                  value: index == -1
                      ? '0'
                      : (type == PostType.Me
                          ? postViewModel.myPosts[index].comment.length
                              .toString()
                          : postViewModel.followingPosts[index].comment.length
                              .toString()),
                  isLoading: isLoading,
                  onTap: () {
                    //TODO on cmt tap
                    Provider.of<CommentViewModel>(context, listen: false)
                        .onPostSelected(type == PostType.Me
                            ? postViewModel.myPosts[index]
                            : postViewModel.followingPosts[index]);
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
              height: 20,
              color: kSecondaryColor,
            ),
          )
        : Row(
            children: [
              InkWell(
                child: SvgPicture.asset(
                  iconName,
                  height: 20,
                ),
                onTap: onTap,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                value,
                style: kPostTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kDividerColor,
                ),
              )
            ],
          );
  }
}

class PostColumnText extends StatelessWidget {
  final String value;
  final String description;
  final bool isLoading;
  const PostColumnText(
      {@required this.value,
      @required this.description,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? Shimmer.fromColors(
                baseColor: kSecondaryColor,
                highlightColor: Colors.grey[100],
                child: Container(
                  width: 80,
                  height: 15,
                  color: kSecondaryColor,
                ),
              )
            : Text(
                value,
                style: kPostTextStyle.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
        isLoading
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Shimmer.fromColors(
                  baseColor: kSecondaryColor,
                  highlightColor: Colors.grey[100],
                  child: Container(
                    width: 80,
                    height: 15,
                    color: kSecondaryColor,
                  ),
                ),
              )
            : Text(
                description,
                style: kPostTextStyle,
              ),
      ],
    );
  }
}
