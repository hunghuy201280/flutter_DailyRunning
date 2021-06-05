import 'package:flutter/material.dart';

class RecordViewModel extends ChangeNotifier {
  bool _isExpand = true;
  bool _isStop = false;

  set isExpand(bool val) {
    _isExpand = val;
    notifyListeners();
  }

  void toggleExpand() {
    _isExpand = !_isExpand;
    notifyListeners();
  }

  void toggleStop() {
    _isStop = !_isStop;
    notifyListeners();
  }

  get isExpand => _isExpand;
  get isStop => _isStop;
}
