import 'dart:async';
import 'dart:io';

import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'gift.dart';

class GiftViewModel extends ChangeNotifier {
  List<Gift> gifts = [];
  StreamSubscription giftChangeSub;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  RunningUser currentUser;
  bool isNewGift = true;
  Gift selectedGift;
  GiftViewModel() {
    if (giftChangeSub != null) giftChangeSub.cancel();
    giftChangeSub = RunningRepo.getGiftStream().listen((event) {
      gifts.addAll(event);
      notifyListeners();
    });
  }

  update(UserViewModel userViewModel) {
    currentUser = userViewModel.currentUser;
  }

  Future<String> onExchangeClick(Gift gift) async {
    if (currentUser.point < gift.point)
      return "Không đủ điểm";
    else {
      await RunningRepo.exchangeGift(currentUser.point - gift.point);
      return null;
    }
  }
}
