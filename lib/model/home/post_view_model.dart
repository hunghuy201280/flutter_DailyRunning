import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:flutter/cupertino.dart';

class PostViewModel extends ChangeNotifier {
  List<Post> followingPosts = [];
  List<Post> myPosts = [];
  List<bool> isLiked = [];
  Like myLike = Like(
    userID: RunningRepo.auth.currentUser.uid,
    avatarUrl: RunningRepo.auth.currentUser.photoURL,
    userName: RunningRepo.auth.currentUser.displayName,
  );
  Future<List<Post>> myPostsFuture;

  void resetData() {
    followingPosts.clear();
    myPosts.clear();
    myPostsFuture = null;
    isLiked.clear();

    myLike = Like(
      userID: RunningRepo.auth.currentUser.uid,
      avatarUrl: RunningRepo.auth.currentUser.photoURL,
      userName: RunningRepo.auth.currentUser.displayName,
    );
  }

  void toggleLike(index) async {
    if (!isLiked[index]) {
      myPosts[index].like.add(myLike);
      isLiked[index] = true;
    } else {
      myPosts[index]
          .like
          .removeWhere((likeUser) => likeUser.userID == myLike.userID);
      isLiked[index] = false;
    }
    RunningRepo.updateLikeForPost(myPosts[index], myPosts[index].like);
    notifyListeners();
  }

  Future<void> getMyPost() async {
    var stream = RunningRepo.getUserPost();
    await for (var posts in stream) {
      if (posts.length == myPosts.length) return;
      myPosts.clear();
      myPosts.addAll(posts);
      isLiked = myPosts
          .map(
            (post) => post.like.any((userLiked) =>
                userLiked.userID == RunningRepo.auth.currentUser.uid),
          )
          .toList();
      myPostsFuture = Future.value(myPosts);
      print(
          'new data length ${posts.length}   mypost length ${myPosts.length}');
      notifyListeners();
    }
  }
}
