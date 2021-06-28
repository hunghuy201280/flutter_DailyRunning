import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_daily_running_admin/repository/running_repo.dart';
import 'package:image_picker/image_picker.dart';

import 'gift.dart';

class GiftViewModel extends ChangeNotifier {
  List<Gift> gifts = [];
  StreamSubscription giftChangeSub;
  File image;
  FocusNode providerFocusNode = FocusNode();
  FocusNode detailFocusNode = FocusNode();
  FocusNode pointFocusNode = FocusNode();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  bool isNewGift = true;
  TextEditingController providerController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController pointController = TextEditingController();
  Gift selectedGift;
  GiftViewModel() {
    if (giftChangeSub != null) giftChangeSub.cancel();
    giftChangeSub = RunningRepo.getGiftStream().listen((event) {
      gifts.addAll(event);
      print("gift added");
    });
  }
  void onAddClick() {
    isNewGift = true;
    providerController.clear();
    detailController.clear();
    pointController.clear();
    image = null;
  }

  void onEditClick(Gift selectedGift) {
    isNewGift = false;
    this.selectedGift = selectedGift;
    providerController.text = selectedGift.providerName;
    detailController.text = selectedGift.giftDetail;
    pointController.text = selectedGift.point.toString();
  }

  Future<File> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    var image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
      return Future.value(image);
    } else {
      return null;
    }
  }

  void onGiftImagePick(ImageSource source) async {
    image = await getImage(source);
    notifyListeners();
  }

  void onAddGift(void Function(String) onComplete) async {
    isLoading = true;
    if (providerController.text.isEmpty ||
        detailController.text.isEmpty ||
        pointController.text.isEmpty ||
        image == null) {
      onComplete("Vui lòng nhập đầy đủ thông tin!");
    } else {
      String giftID = RunningRepo.uuid.v4();
      String url = await RunningRepo.postFile(
        imageFile: image,
        folderPath: "gift_images",
        fileName: giftID,
      );
      Gift newGift = Gift(
          iD: giftID,
          photoUri: url,
          providerName: providerController.text,
          giftDetail: detailController.text,
          point: int.parse(pointController.text));
      await RunningRepo.setGift(newGift);
      onComplete(null);
      image = null;
      providerController.clear();
      detailController.clear();
      pointController.clear();
    }
    isLoading = false;
  }

  void onUpdateGift(void Function(String) onComplete) async {
    isLoading = true;
    if (providerController.text.isEmpty ||
        detailController.text.isEmpty ||
        pointController.text.isEmpty) {
      onComplete("Vui lòng nhập đầy đủ thông tin!");
    } else {
      if (image != null) {
        String url = await RunningRepo.postFile(
            imageFile: image,
            folderPath: "gift_images",
            fileName: selectedGift.iD);
        selectedGift.photoUri = url;
      }
      selectedGift.point = int.parse(pointController.text);
      selectedGift.giftDetail = detailController.text;
      selectedGift.providerName = providerController.text;
      await RunningRepo.setGift(selectedGift);
      onComplete(null);
      image = null;
      providerController.clear();
      detailController.clear();
      pointController.clear();
    }
    isLoading = false;
  }
}
