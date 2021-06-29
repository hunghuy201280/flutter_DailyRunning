import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/model/home/comment_view_model.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/user/other_user/other_profile_view_model.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/home/widgets/post_list_view.dart';
import 'package:daily_running/ui/home/widgets/post_view.dart';
import 'package:daily_running/ui/user/other_user/other_user_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CommentScreen extends StatelessWidget {
  static final id = 'CommentScreen';

  const CommentScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Bình luận',
            style: kBigTitleTextStyle,
          ),
          backgroundColor: kPrimaryColor,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<CommentViewModel>(
                  builder: (context, viewModel, _) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommentItem(
                          avatarUrl: viewModel.selectedPost.ownerAvatarUrl,
                          ownerName: viewModel.selectedPost.ownerName,
                          ownerID: viewModel.selectedPost.ownerID,
                          content: viewModel.selectedPost.activity.describe,
                          time: CommentViewModel.getDuration(
                              viewModel.selectedPost.activity.dateCreated),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    if (viewModel.selectedPost.comment[index]
                                            .ownerID ==
                                        RunningRepo.auth.currentUser.uid)
                                      return;
                                    Provider.of<OtherProfileViewModel>(context,
                                            listen: false)
                                        .onUserSelected(viewModel.selectedPost
                                            .comment[index].ownerID);
                                    pushNewScreen(
                                      context,
                                      screen: OtherUserScreen(),
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                      withNavBar: false,
                                    );
                                  },
                                  child: CommentItem(
                                    ownerID: viewModel
                                        .selectedPost.comment[index].ownerID,
                                    content: viewModel
                                        .selectedPost.comment[index].content,
                                    time: CommentViewModel.getDuration(viewModel
                                        .selectedPost
                                        .comment[index]
                                        .dateCreated),
                                  ),
                                ),
                              );
                            },
                            itemCount: viewModel.selectedPost.comment.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: kPrimaryColor,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: RunningRepo.auth.currentUser.photoURL,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 30,
                    ),
                    placeholder: (context, url) => Shimmer.fromColors(
                      child: CircleAvatar(
                        radius: 30,
                      ),
                      baseColor: kSecondaryColor,
                      highlightColor: Colors.grey[100],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller:
                            Provider.of<CommentViewModel>(context).controller,
                        decoration: InputDecoration(
                          hintText: 'Thêm bình luận...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          suffixIcon: TextButton(
                            style: TextButton.styleFrom(
                              primary: kPrimaryColor,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              Provider.of<CommentViewModel>(context,
                                      listen: false)
                                  .onCommentPost();
                            },
                            child: Text(
                              'Đăng',
                              style: kBigTitleTextStyle.copyWith(
                                  fontSize: 13, color: kDoveGrayColor),
                            ),
                          ),
                          suffixIconConstraints:
                              BoxConstraints.tightFor(width: 60, height: 35),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentItem extends StatefulWidget {
  final String ownerID;
  final String content;
  final String time;
  final String avatarUrl;
  final String ownerName;
  const CommentItem({
    @required this.content,
    @required this.time,
    @required this.ownerID,
    this.avatarUrl,
    this.ownerName,
  });
  @override
  _CommentItemState createState() => _CommentItemState();

  static final placeHolder = Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Shimmer.fromColors(
        child: CircleAvatar(
          radius: 22,
        ),
        baseColor: kSecondaryColor,
        highlightColor: Colors.grey[100],
      ),
      SizedBox(
        width: 12,
      ),
      Expanded(
        child: Shimmer.fromColors(
          baseColor: kSecondaryColor,
          highlightColor: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: '           ',
                  style: kBigTitleTextStyle.copyWith(
                      fontSize: 14, color: kMineShaftColor),
                  children: [
                    TextSpan(
                      text:
                          '                                                         ',
                      style: kAvo400TextStyle,
                    ),
                  ],
                ),
              ),
              Text(
                '             ',
                style: kAvo400TextStyle.copyWith(color: kDoveGrayColor),
              ),
            ],
          ),
        ),
      )
    ],
  );
}

class _CommentItemState extends State<CommentItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ownerFuture = RunningRepo.getUserById(widget.ownerID);
  }

  Future<RunningUser> ownerFuture;

  @override
  Widget build(BuildContext context) {
    if (widget.avatarUrl == null || widget.ownerName == null)
      return FutureBuilder<RunningUser>(
        future: ownerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            RunningUser owner = snapshot.data;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: owner.avatarUri,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 22,
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
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: owner.displayName,
                          style: kBigTitleTextStyle.copyWith(
                              fontSize: 14, color: kMineShaftColor),
                          children: [
                            TextSpan(
                              text: '  ${widget.content}',
                              style: kAvo400TextStyle,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.time,
                        style: kAvo400TextStyle.copyWith(color: kDoveGrayColor),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else
            return CommentItem.placeHolder;
        },
      );
    else
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: widget.avatarUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
              radius: 22,
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
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: widget.ownerName,
                    style: kBigTitleTextStyle.copyWith(
                        fontSize: 14, color: kMineShaftColor),
                    children: [
                      TextSpan(
                        text: '  ${widget.content}',
                        style: kAvo400TextStyle,
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.time,
                  style: kAvo400TextStyle.copyWith(color: kDoveGrayColor),
                ),
              ],
            ),
          )
        ],
      );
  }
}
