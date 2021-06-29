import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/record/record_view_model.dart';
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

  static String getDuration(String date) {
    DateTime commentDate = RecordViewModel.activityDateFormat.parse(date);
    return toDuration(DateTime.now().millisecondsSinceEpoch -
        commentDate.millisecondsSinceEpoch);
  }

  static final List<int> times = [
    Duration(days: 365).inMilliseconds,
    Duration(days: 30).inMilliseconds,
    Duration(days: 1).inMilliseconds,
    Duration(hours: 1).inMilliseconds,
    Duration(minutes: 1).inMilliseconds,
  ];
  static final List<String> timesString = [
    "năm",
    "tháng",
    "ngày",
    "giờ",
    "phút",
  ];

  static String toDuration(int duration) {
    StringBuffer res = new StringBuffer();
    for (int i = 0; i < times.length; i++) {
      int current = times[i];
      int temp = duration ~/ current;
      if (temp > 0) {
        res..write(temp)..write(" ")..write(timesString[i])..write(" trước");
        break;
      }
    }
    if ("" == (res.toString()))
      return "0 giây trước";
    else
      return res.toString();
  }
}
