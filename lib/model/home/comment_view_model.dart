import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/model/home/post_view_model.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:flutter/cupertino.dart';

class CommentViewModel extends ChangeNotifier {
  Post selectedPost;
  TextEditingController controller = TextEditingController();
  void onPostSelected(Post post) {
    controller.clear();
    selectedPost = post;
    listenForPostChange();
  }

  Future listenForPostChange() async {
    await for (var postChange in RunningRepo.getPostStream(selectedPost)) {
      selectedPost = postChange;
      notifyListeners();
    }
  }

  void onCommentPost() async {
    if (controller.text.trim().isNotEmpty) {
      RunningRepo.postComment(
          selectedPost,
          Comment(
            commentID: RunningRepo.uuid.v4(),
            content: controller.text.trim(),
            dateCreated:
                RecordViewModel.activityDateFormat.format(DateTime.now()),
            ownerID: RunningRepo.auth.currentUser.uid,
          ));
      controller.clear();
    }
  }
}
