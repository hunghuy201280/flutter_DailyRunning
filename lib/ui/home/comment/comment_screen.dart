import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/ui/home/widgets/post_list_view.dart';
import 'package:daily_running/ui/home/widgets/post_view.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommentItem(
                        userName: 'username username username ',
                        content:
                            'describe describe describe describe describe describe describe describe describe describe ',
                        time: '2d',
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
                            return CommentItem(
                              userName: 'username username username ',
                              content:
                                  'describe describe describe describe describe describe describe describe describe describe ',
                              time: '2d',
                            );
                          },
                          itemCount: 10,
                        ),
                      ),
                    ],
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
                    imageUrl: kLightImage,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 30,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
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
                            onPressed: () {},
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

class CommentItem extends StatelessWidget {
  final String userName;
  final String content;
  final String time;

  const CommentItem(
      {@required this.userName, @required this.content, @required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: kLightImage,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
            radius: 22,
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
                  text: userName,
                  style: kBigTitleTextStyle.copyWith(
                      fontSize: 14, color: kMineShaftColor),
                  children: [
                    TextSpan(
                      text: content,
                      style: kAvo400TextStyle,
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: kAvo400TextStyle.copyWith(color: kDoveGrayColor),
              ),
            ],
          ),
        )
      ],
    );
  }
}
