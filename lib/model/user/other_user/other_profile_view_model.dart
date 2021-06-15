import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/record/activity_view_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class OtherProfileViewModel extends ChangeNotifier {
  RunningUser selectedUser;
  bool _isLoading = false;
  bool _isFollowed = false;
  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  bool get isFollowed => _isFollowed;
  set isFollowed(val) {
    _isFollowed = val;
    notifyListeners();
  }

  Future<bool> loadingFuture;
  bool get isLoading => _isLoading;
  List<Post> posts = [];
  List<bool> isLiked = [];
  Future<void> onUserSelected(String uid) async {
    isLoading = true;
    selectedUser = await RunningRepo.getUserById(uid);
    notifyListeners();
    posts = await RunningRepo.getUserPostById(uid);
    isFollowed = await RunningRepo.checkFollow(uid);
    isLiked = posts
        .map((e) => e.like.any(
            (element) => element.userID == RunningRepo.auth.currentUser.uid))
        .toList();
    await getStatistic();
    loadingFuture = Future.value(false);
    isLoading = false;
  }

  //region statistic
  List<double> distancesStatistic = [0, 0, 0];
  List<int> timeWorkingStatistic = [0, 0, 0];
  List<int> workingCountStatistic = [0, 0, 0];
  //0= week 1= month 2= year
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  List<Activity> userActivities = [];
  void resetData() {
    distancesStatistic = [0, 0, 0];
    timeWorkingStatistic = [0, 0, 0];
    workingCountStatistic = [0, 0, 0];
    userActivities = [];
    mapMarkers.clear();
    _polylines.clear();
  }

  void getWeekStatistic() async {
    DateTime today = DateTime.now();
    var sundayOfLastWeek = today.subtract(new Duration(days: today.weekday));
    var mondayOfNextWeek = sundayOfLastWeek.add(Duration(days: 8));

    List<Activity> weekActivity = userActivities.where((act) {
      DateTime actDate = dateFormat.parse(act.dateCreated.substring(0, 10));
      return actDate.isBefore(mondayOfNextWeek) &&
          actDate.isAfter(sundayOfLastWeek);
    }).toList();
    distancesStatistic[0] = 0;
    timeWorkingStatistic[0] = 0;
    workingCountStatistic[0] = 0;
    weekActivity.forEach((act) {
      distancesStatistic[0] += act.distance;
      timeWorkingStatistic[0] += act.duration;
    });
    workingCountStatistic[0] = weekActivity.length;
    distancesStatistic[0] /= 1000;
  }

  void getMonthStatistic() {
    DateTime today = DateTime.now();
    var lastDayOfLastMonth = DateTime(today.year, today.month, 0);
    var firstDayOfNextMonth = DateTime(today.year, today.month + 1, 1);
    List<Activity> monthActivity = userActivities.where((act) {
      DateTime actDate = dateFormat.parse(act.dateCreated.substring(0, 10));
      return actDate.isBefore(firstDayOfNextMonth) &&
          actDate.isAfter(lastDayOfLastMonth);
    }).toList();
    distancesStatistic[1] = 0;
    timeWorkingStatistic[1] = 0;
    workingCountStatistic[1] = 0;
    monthActivity.forEach((act) {
      distancesStatistic[1] += act.distance;
      timeWorkingStatistic[1] += act.duration;
    });
    workingCountStatistic[1] = monthActivity.length;
    distancesStatistic[1] /= 1000;
  }

  void getYearStatistic() {
    DateTime today = DateTime.now();
    var lastDayOfLastYear = DateTime(today.year, 1, 0);
    var firstDayOfNextYear = DateTime(today.year + 1, 1, 1);
    List<Activity> yearActivity = userActivities.where((act) {
      DateTime actDate = dateFormat.parse(act.dateCreated.substring(0, 10));
      return actDate.isBefore(firstDayOfNextYear) &&
          actDate.isAfter(lastDayOfLastYear);
    }).toList();
    distancesStatistic[2] = 0;
    timeWorkingStatistic[2] = 0;
    workingCountStatistic[2] = 0;
    yearActivity.forEach((act) {
      distancesStatistic[2] += act.distance;
      timeWorkingStatistic[2] += act.duration;
    });
    workingCountStatistic[2] = yearActivity.length;
    distancesStatistic[2] /= 1000;
  }

  Future<void> getStatistic() async {
    resetData();
    userActivities = posts.map((e) => e.activity).toList();
    getWeekStatistic();
    getMonthStatistic();
    getYearStatistic();
  }
//endregion

  //region follow
  void onFollowClick() async {
    if (isFollowed) {
      isFollowed = false;
      await RunningRepo.unfollowUser(selectedUser.userID);
    } else {
      isFollowed = true;
      await RunningRepo.followUser(selectedUser);
    }
    notifyListeners();
  }

  //endregion

//region map view
  List<Marker> mapMarkers = [];
  Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;
  Activity selectedActivity;
  Uint8List startMarkerImage;
  Uint8List endMarkerImage;
  GoogleMapController mapController;
  void disposeMap() {
    mapController.dispose();
    _polylines.clear();
    mapMarkers = [];
    selectedActivity = null;
  }

  void createPolyline(List<LatLng> polylineCoordinates) {
    // create a Polyline instance
    // with an id, an RGB color and the list of LatLng pairs
    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: kPrimaryColor,
      points: polylineCoordinates,
    );

    // add the constructed polyline as a set of points
    // to the polyline set, which will eventually
    // end up showing up on the map
    _polylines.clear();
    _polylines.add(polyline);
    notifyListeners();
  }

  Future<void> createMarkers(
      List<LatLng> polylineCoordinates, BuildContext context) async {
    if (startMarkerImage == null) {
      startMarkerImage = await RecordViewModel.getMarker('start', context);
      endMarkerImage = await RecordViewModel.getMarker('end', context);
    }
    mapMarkers.addAll([
      Marker(
        icon: BitmapDescriptor.fromBytes(startMarkerImage),
        draggable: false,
        markerId: MarkerId('markerStart'),
        anchor: Offset(0.5, 1),
        zIndex: 2,
        position: polylineCoordinates.first,
      ),
      Marker(
        icon: BitmapDescriptor.fromBytes(endMarkerImage),
        draggable: false,
        markerId: MarkerId('markerEnd'),
        anchor: Offset(0.5, 1),
        zIndex: 2,
        position: polylineCoordinates.last,
      ),
    ]);
  }

  void onActivitySelected(BuildContext context, int index) async {
    selectedActivity = posts[index].activity;
    pushNewScreen(context,
        screen: ActivityView(type: ActivityViewType.FromFollowing),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.cupertino);
    isLoading = true;
  }

  void showActivityToMap(
      BuildContext context, GoogleMapController mapController) async {
    this.mapController = mapController;
    List<LatLng> selectedActivityLatLngs = selectedActivity.latLngArrayList
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
    createPolyline(selectedActivityLatLngs);
    await createMarkers(selectedActivityLatLngs, context);
    var bounds = RecordViewModel.boundsFromLatLngList(selectedActivityLatLngs);
    CameraUpdate cu = CameraUpdate.newLatLngBounds(bounds, 25);
    await mapController.moveCamera(cu);
    isLoading = false;
  }

//endregion
}