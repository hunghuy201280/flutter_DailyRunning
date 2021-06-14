import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:flutter/cupertino.dart';

import 'follow.dart';
import 'other_profile_view_model.dart';

class OtherFollowViewModel extends ChangeNotifier {
  List<Follow> follower = [];
  List<Follow> following = [];
  RunningUser selectedUser;

  void update(OtherProfileViewModel viewModel) {
    selectedUser = viewModel.selectedUser;
    getFollow();
  }

  void resetData() {
    follower.clear();
    following.clear();
  }

  void getFollow() async {
    var res = await Future.wait([
      RunningRepo.getFollower(selectedUser.userID),
      RunningRepo.getFollowing(selectedUser.userID)
    ]);
    follower = res[0];
    following = res[1];
    notifyListeners();
  }
}
