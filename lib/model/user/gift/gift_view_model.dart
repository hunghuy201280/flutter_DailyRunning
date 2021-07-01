import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      event.forEach((element) {
        Gift giftChange = Gift.fromJson(element.doc.data());
        if (element.type == DocumentChangeType.added) {
          gifts.add(giftChange);
        } else if (element.type == DocumentChangeType.removed) {
          int deletedIndex =
              gifts.indexWhere((element) => element.iD == giftChange.iD);
          if (deletedIndex > 0) {
            gifts.removeAt(deletedIndex);
          }
        } else if (element.type == DocumentChangeType.modified) {
          int updatedIndex =
              gifts.indexWhere((element) => element.iD == giftChange.iD);
          if (updatedIndex > 0) {
            gifts[updatedIndex] = giftChange;
          }
        }
      });
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
