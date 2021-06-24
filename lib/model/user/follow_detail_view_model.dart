import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:flutter/cupertino.dart';

import 'other_user/follow.dart';

class FollowDetailViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  Post currentPost;
  String title = "";
  List<RunningUser> data = [];
  void onPostSelected(Post post) async // hiển thị ng like
  {
    title = "Người thích";
    isLoading = true;
    currentPost = post;
    await loadUserInfo(currentPost.likeUserID);
    isLoading = false;
  }

  Future<void> loadUserInfo(List<String> uid) async {
    data.clear();
    for (int i = 0; i < uid.length; i++) {
      RunningUser temp = await RunningRepo.getUserById(uid[i]);
      data.add(temp);
    }
  }

  List<String> currentFollowData = [];
  void onUserSelected(String title, List<Follow> data) async //hiển thị follow
  {
    this.title = title;
    currentFollowData = data.map((e) => e.uid).toList();
    isLoading = true;
    await loadUserInfo(currentFollowData);
    isLoading = false;
  }
}
