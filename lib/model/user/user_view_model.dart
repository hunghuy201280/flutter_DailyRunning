import 'package:daily_running/model/user/running_user.dart';
import 'package:flutter/cupertino.dart';

class UserViewModel extends ChangeNotifier {
  RunningUser _currentUser;
  set currentUser(RunningUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void setCurrentUserNoNotify(RunningUser user) {
    _currentUser = user;
  }

  RunningUser get currentUser => _currentUser;
}
