import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarViewModel extends ChangeNotifier {
  bool _isHideNavbar = false;
  set isHideNavbar(bool val) {
    _isHideNavbar = val;
    notifyListeners();
  }

  get isHideNavbar => _isHideNavbar;
}
