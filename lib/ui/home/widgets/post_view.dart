import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/model/home/post_view_model.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostView extends StatelessWidget {
  static String getTimeWorkingInMinute(int timeWorkingInSec) {
    return '${(timeWorkingInSec.toDouble() / 60).toStringAsFixed(2)}';
  }

  final int index;
  final bool isLoading;
  const PostView({
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
                    : CachedNetworkImage(
                        imageUrl: postViewModel.myPosts[index].ownerAvatarUrl,
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
                            postViewModel.myPosts[index].ownerName,
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
                            postViewModel.myPosts[index].activity.dateCreated,
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
                    postViewModel.myPosts[index].activity.describe ?? "",
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
                      '${isLoading ? 0 : (postViewModel.myPosts[index].activity.distance / 1000).toStringAsFixed(2)}Km',
                  description: 'Quãng đường',
                  isLoading: isLoading,
                ),
                PostColumnText(
                  value:
                      '${isLoading ? 0 : PostView.getTimeWorkingInMinute(postViewModel.myPosts[index].activity.duration)} phút',
                  description: 'Thời gian',
                  isLoading: isLoading,
                ),
                PostColumnText(
                  value:
                      '${(isLoading ? 0 : postViewModel.myPosts[index].activity.pace * 60).toStringAsFixed(2)} m/ph',
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
                    imageUrl: postViewModel.myPosts[index].activity.pictureURI,
                    imageBuilder: (context, imageProvider) => SizedBox.fromSize(
                      size: Size(double.infinity, 180),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.fill,
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
                      : 'assets/images/ic_heart${postViewModel.isLiked[index] ? '_filled' : ''}.svg',
                  value: index == -1
                      ? '0'
                      : postViewModel.myPosts[index].like.length.toString(),
                  isLoading: isLoading,
                  onTap: () {
                    //TODO on like tap
                    Provider.of<PostViewModel>(context, listen: false)
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
                      : postViewModel.myPosts[index].comment.length.toString(),
                  isLoading: isLoading,
                  onTap: () {
                    //TODO on cmt tap
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
