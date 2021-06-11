import 'dart:io';

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
}
