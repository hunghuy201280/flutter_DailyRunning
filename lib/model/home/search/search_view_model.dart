import 'dart:ui';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchViewModel extends ChangeNotifier {
  bool _showSearchBar = false;
  List<RunningUser> searchData = [];
  Stream<List<RunningUser>> searchDataStream;
  List<RunningUser> searchResult = [];
  FloatingSearchBarController searchBarController =
      FloatingSearchBarController();
  String searchQuery = '';
  void resetData() async {
    searchBarController = FloatingSearchBarController();
    searchDataStream = null;
    searchData.clear();
    searchQuery = '';
    getSearchData();
  }

  set showSearchBar(val) {
    _showSearchBar = val;
    notifyListeners();
  }

  void getSearchData() async {
    searchDataStream = RunningRepo.getSearchData();
    await for (var users in searchDataStream) {
      searchData.clear();
      searchData.addAll(users);
      searchData.removeWhere(
          (element) => element.userID == RunningRepo.auth.currentUser.uid);
    }
  }

  void search(String query) {
    searchQuery = query;
    if (query.isNotEmpty)
      searchResult = searchData
          .where((element) =>
              element.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    else
      searchResult.clear();
    notifyListeners();
  }

  bool get showSearchBar => _showSearchBar;

  AnimationController animationController;
  void showSearchBarAnimated() async {
    await animationController.forward();
    searchBarController.show();
    searchBarController.open();
    _showSearchBar = true;
  }

  void hideSearchBar() async {
    searchBarController.clear();
    searchResult.clear();
    searchBarController.close();

    searchBarController.hide();
    await animationController.reverse();

    _showSearchBar = false;
  }
}
