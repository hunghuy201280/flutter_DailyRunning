import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_running/model/user/other_user/follow.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UserViewModel extends ChangeNotifier {
  RunningUser _currentUser;
  final picker = ImagePicker();
  bool _isLoading = false;
  set currentUser(RunningUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void setCurrentUserNoNotify(RunningUser user) {
    _currentUser = user;
    listenToFollowerChange();
    listenToFollowingChange();
  }

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void onAvatarChange(ImageSource source) async {
    isLoading = true;
    final image = await getImage(source);
    if (image != null) {
      final newAvatarUrl = await RunningRepo.postFile(
          imageFile: image,
          folderPath: 'avatar_photos',
          fileName: currentUser.userID);
      currentUser.avatarUri = newAvatarUrl;
      await RunningRepo.updateUserInfo(currentUser);
    }
    isLoading = false;
  }

  RunningUser get currentUser => _currentUser;
  Future<File> getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    var image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
      return Future.value(image);
    } else {
      return null;
    }
  }

  Future<void> addRunningPoint(int point) async {
    RunningRepo.addRunningPoint(_currentUser, point);
    _currentUser.point += point;
    notifyListeners();
  }

  //region follow
  List<Follow> follower = [];
  List<Follow> following = [];

  void listenToFollowerChange() async {
    follower.clear();
    var stream = RunningRepo.getFollowerStream();
    await for (var event in stream) {
      event.docChanges.forEach((change) {
        Follow followChange = Follow.fromJson(change.doc.data());

        if (change.type == DocumentChangeType.added) {
          follower.add(followChange);
        } else if (change.type == DocumentChangeType.removed) {
          int deletedIndex =
              follower.indexWhere((element) => element.uid == followChange.uid);
          if (deletedIndex >= 0) follower.removeAt(deletedIndex);
        }
      });
      notifyListeners();
    }
  }

  void listenToFollowingChange() async {
    following.clear();
    var stream = RunningRepo.getFollowingStream();
    await for (var event in stream) {
      event.docChanges.forEach((change) {
        Follow followChange = Follow.fromJson(change.doc.data());

        if (change.type == DocumentChangeType.added) {
          following.add(followChange);
        } else if (change.type == DocumentChangeType.removed) {
          int deletedIndex = following
              .indexWhere((element) => element.uid == followChange.uid);
          if (deletedIndex > 0) following.removeAt(deletedIndex);
        }
      });
      notifyListeners();
    }
  }
  //endregion
}
