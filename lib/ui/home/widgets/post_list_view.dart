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
  final shimmerPost = ListView.builder(
    itemBuilder: (context, index) {
      return PostView(
        index: -1,
        isLoading: true,
        type: PostType.Me,
      );
    },
    itemCount: 3,
  );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<PostViewModel>(
      builder: (context, viewModel, _) => (widget.type == PostType.Me
              ? viewModel.myPostLoading
              : viewModel.followingPostLoading)
          ? shimmerPost
          : ((widget.type == PostType.Me && viewModel.myPosts.isEmpty) ||
                  (widget.type == PostType.Following &&
                      viewModel.followingPosts.isEmpty))
              ? Center(
                  child: Text('Không có post nào'),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return PostView(
                      index: index,
                      isLoading: false,
                      type: widget.type,
                    );
                  },
                  itemCount: widget.type == PostType.Me
                      ? viewModel.myPosts.length
                      : viewModel.followingPosts.length,
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
