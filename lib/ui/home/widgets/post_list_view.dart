import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/model/home/post_view_model.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/ui/home/widgets/post_view.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostListView extends StatefulWidget {
  const PostListView({@required this.type});
  static Future<List<Post>> getTempActivity() async {
    await Future.delayed(Duration(days: 1));
    return null;
  }

  final PostType type;

  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView>
    with AutomaticKeepAliveClientMixin<PostListView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Post>>(
      future: widget.type == PostType.Me
          ? Provider.of<PostViewModel>(context).myPostsFuture
          : PostListView.getTempActivity(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Post> posts = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              return PostView(
                index: index,
                isLoading: !(snapshot.connectionState == ConnectionState.done),
                type: widget.type,
              );
            },
            itemCount: posts.length,
          );
        } else
          return ListView.builder(
            itemBuilder: (context, index) {
              return PostView(
                index: -1,
                isLoading: true,
                type: widget.type,
              );
            },
            itemCount: 3,
          );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
