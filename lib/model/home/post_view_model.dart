import 'dart:typed_data';

import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/record/activity_view_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class PostViewModel extends ChangeNotifier {
  List<Post> followingPosts = [];
  List<Post> myPosts = [];
  List<bool> isLikedMyPost = [];
  List<bool> isLikedFollowingPost = [];
  List<Marker> mapMarkers = [];
  Set<Polyline> _polylines = {};
  bool _followingPostLoading = true;
  bool _myPostLoading = true;
  bool _isLoading = false;
  Activity selectedActivity;
  Uint8List startMarkerImage;
  Uint8List endMarkerImage;
  GoogleMapController mapController;

  set followingPostLoading(val) {
    _followingPostLoading = val;
    notifyListeners();
  }

  bool get followingPostLoading => _followingPostLoading;
  set myPostLoading(val) {
    _myPostLoading = val;
    notifyListeners();
  }

  bool get myPostLoading => _myPostLoading;
  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  Like myLike = Like(
    userID: RunningRepo.auth.currentUser.uid,
    avatarUrl: RunningRepo.auth.currentUser.photoURL,
    userName: RunningRepo.auth.currentUser.displayName,
  );

  Set<Polyline> get polylines => _polylines;

  void disposeMap() {
    mapController.dispose();
    _polylines.clear();
    mapMarkers = [];
    selectedActivity = null;
  }

  void resetData() {
    _isLoading = false;
    followingPosts.clear();
    myPosts.clear();

    isLikedMyPost.clear();
    selectedActivity = null;
    _followingPostLoading = true;
    _myPostLoading = true;
    mapMarkers = [];
    _polylines.clear();
    if (mapController != null) mapController.dispose();
    myLike = Like(
      userID: RunningRepo.auth.currentUser.uid,
      avatarUrl: RunningRepo.auth.currentUser.photoURL,
      userName: RunningRepo.auth.currentUser.displayName,
    );
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

  void onActivitySelected(
      BuildContext context, int index, PostType type) async {
    if (type == PostType.Me) {
      selectedActivity = myPosts[index].activity;
    } else {
      selectedActivity = followingPosts[index].activity;
    }
    pushNewScreen(context,
        screen: ActivityView(type: ActivityViewType.FromHomeScreen),
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

  void toggleLike(index) async {
    if (!isLikedMyPost[index]) {
      myPosts[index].like.add(myLike);
      isLikedMyPost[index] = true;
    } else {
      myPosts[index]
          .like
          .removeWhere((likeUser) => likeUser.userID == myLike.userID);
      isLikedMyPost[index] = false;
    }
    RunningRepo.updateLikeForPost(myPosts[index], myPosts[index].like);
    notifyListeners();
  }

  void checkExistMyPostData() async {
    await Future.delayed(Duration(seconds: 4));
    if (myPosts.isNotEmpty) return;
  }

  void checkExistFollowingPostData() async {
    await Future.delayed(Duration(seconds: 4));
    if (followingPosts.isNotEmpty) return;
  }

  Future<void> getMyPost() async {
    var stream = RunningRepo.getUserPostChanges();
    myPosts.clear();
    //todo bỏ comment dòng này
    checkExistMyPostData();
    await for (var posts in stream) {
      if (myPosts.isEmpty) {
        myPosts.addAll(posts);
        isLikedMyPost = myPosts
            .map(
              (post) => post.like.any((userLiked) =>
                  userLiked.userID == RunningRepo.auth.currentUser.uid),
            )
            .toList();
      } else {
        posts.forEach((changedPost) {
          int index =
              myPosts.indexWhere((post) => post.postID == changedPost.postID);
          print('index of changed post $index');
          if (index >= 0)
            myPosts[index] = changedPost;
          else {
            myPosts.add(changedPost);
          }
        });
      }
      isLikedMyPost = myPosts
          .map(
            (post) => post.like.any((userLiked) =>
                userLiked.userID == RunningRepo.auth.currentUser.uid),
          )
          .toList();
      myPostLoading = false;
    }
  }

  Future<void> getMyFollowingPost() async {
    var stream = RunningRepo.getFollowingPostChanges();
    followingPosts.clear();
    //todo bỏ comment dòng này
    checkExistFollowingPostData();
    await for (var posts in stream) {
      if (followingPosts.isEmpty) {
        followingPosts.addAll(posts);
      } else {
        posts.forEach((changedPost) {
          int index = followingPosts
              .indexWhere((post) => post.postID == changedPost.postID);
          print('index of changed post $index');
          if (index >= 0)
            followingPosts[index] = changedPost;
          else
            followingPosts.add(changedPost);
        });
      }
      isLikedFollowingPost = followingPosts
          .map(
            (post) => post.like.any((userLiked) =>
                userLiked.userID == RunningRepo.auth.currentUser.uid),
          )
          .toList();
      followingPostLoading = false;
    }
  }
}
