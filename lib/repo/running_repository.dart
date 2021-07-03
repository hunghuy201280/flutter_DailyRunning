import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_running/model/home/post.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/user/gift/gift.dart';
import 'package:daily_running/model/user/other_user/follow.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:async/async.dart' as FlutterAsync;

class RunningRepo {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FacebookAuth _fbAuth = FacebookAuth.instance;
  static AccessToken fbAccessToken;
  static FacebookAuth get fbAuth => _fbAuth;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static Uuid uuid = Uuid();
  static String myLike = RunningRepo.auth.currentUser.uid;
  static final normalDateFormat = DateFormat("dd-MM-yyyy");

  static void resetData() {
    _firestore = FirebaseFirestore.instance;
    _fbAuth = FacebookAuth.instance;
    myLike = RunningRepo.auth.currentUser.uid;
  }

  static Future<String> sendResetPasswordEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "user-not-found") {
        return "Không tìm thấy người dùng nào với email này!";
      } else if (e.code == "invalid-email") return "Email không hợp lệ";

      return null;
    }
  }

  static Stream<List<DocumentChange<Map<String, dynamic>>>>
      getGiftStream() async* {
    var stream = _firestore.collection("gift").snapshots();
    await for (var data in stream) {
      //yield data.docChanges.map((e) => Gift.fromJson(e.doc.data())).toList();
      yield data.docChanges;
    }
  }

  static bool isEmail() {
    return auth.currentUser.providerData[0].providerId == "password";
  }

  static Future<String> changePassword(String newPass, String oldPass) async {
    AuthCredential credential = EmailAuthProvider.credential(
        email: auth.currentUser.email, password: oldPass);
    try {
      await auth.currentUser.reauthenticateWithCredential(credential);
      await auth.currentUser.updatePassword(newPass);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "wrong-password":
          return "Sai mật khẩu";
        default:
          return e.code;
      }
    }
  }

  static Future exchangeGift(int point) async {
    _firestore
        .collection("users")
        .doc(auth.currentUser.uid)
        .update({"point": point});
  }

  static void updateStep(int newStep) {
    _firestore
        .collection("step")
        .doc(auth.currentUser.uid)
        .collection("daily_step")
        .doc(normalDateFormat.format(DateTime.now()))
        .set({"step": newStep});
  }

  static Future<int> getStep() async {
    var doc = await _firestore
        .collection("step")
        .doc(auth.currentUser.uid)
        .collection("daily_step")
        .doc(normalDateFormat.format(DateTime.now()))
        .get();
    int step = 0;
    if (doc.exists) step = doc.data()["step"];
    return step;
  }

  static Future<int> getTarget() async {
    var doc =
        await _firestore.collection("step").doc(auth.currentUser.uid).get();
    int target = 2000;
    if (doc.exists) target = doc.data()["target"];
    return target;
  }

  static Future<void> setTarget(int target) async {
    print("update target $target");
    await _firestore
        .collection("step")
        .doc(auth.currentUser.uid)
        .set({"target": target});
  }

  static Stream<List<RunningUser>> getSearchData() async* {
    await for (var datas in _firestore.collection('users').snapshots()) {
      List<RunningUser> result =
          datas.docs.map((e) => RunningUser.fromJson(e.data())).toList();
      yield result;
    }
  }

  static updateLikeForPost(Post post, List<String> likes) async {
    try {
      _firestore
          .collection('post')
          .doc(post.ownerID)
          .collection('user_posts')
          .doc(post.postID)
          .update({'like': likes});
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Future<void> createPost(Post post) async {
    try {
      await _firestore
          .collection('post')
          .doc(auth.currentUser.uid)
          .collection('user_posts')
          .doc(post.postID)
          .set(post.toJson());
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Stream<List<Post>> getUserPost() async* {
    await for (var newPost in _firestore
        .collection('post')
        .doc(auth.currentUser.uid)
        .collection('user_posts')
        .snapshots()) {
      yield newPost.docs.map((posts) => Post.fromJson(posts.data())).toList();
    }
  }

  static Stream<List<Post>> getUserPostChanges() async* {
    await for (var newPost in _firestore
        .collection('post')
        .doc(auth.currentUser.uid)
        .collection('user_posts')
        .snapshots()) {
      yield newPost.docChanges
          .map((posts) => Post.fromJson(posts.doc.data()))
          .toList();
    }
  }

  static Stream<Post> getPostStream(Post post) async* {
    var stream = _firestore
        .collection('post')
        .doc(post.ownerID)
        .collection('user_posts')
        .doc(post.postID)
        .snapshots();
    await for (var change in stream) {
      yield Post.fromJson(change.data());
    }
  }

  static Stream<List<Post>> getUserPostChangesByID(String uid) async* {
    await for (var newPost in _firestore
        .collection('post')
        .doc(uid)
        .collection('user_posts')
        .snapshots()) {
      yield newPost.docChanges
          .map((posts) => Post.fromJson(posts.doc.data()))
          .toList();
    }
  }

  static Future updateStreamGroup(
      FlutterAsync.StreamGroup<List<Post>> followingPostStreamGroup) async {
    List<Follow> following = [];
    List<Stream<List<Post>>> followingPostStreams = [];
    var stream = RunningRepo.getFollowingStream();
    await for (var event in stream) {
      event.docChanges.forEach((change) {
        Follow followChange = Follow.fromJson(change.doc.data());
        if (change.type == DocumentChangeType.added) {
          following.add(followChange);
          var newStream = getUserPostChangesByID(followChange.uid);
          followingPostStreams.add(newStream);
          followingPostStreamGroup.add(newStream);
        } else if (change.type == DocumentChangeType.removed) {
          int deletedIndex = following
              .indexWhere((element) => element.uid == followChange.uid);
          if (deletedIndex > 0) {
            following.removeAt(deletedIndex);
            var deletedStream = followingPostStreams.removeAt(deletedIndex);
            followingPostStreamGroup.remove(deletedStream);
          }
        }
      });
    }
  }

  static Stream<List<Post>> getFollowingPostChanges() async* {
    FlutterAsync.StreamGroup<List<Post>> followingPostStreamGroup =
        FlutterAsync.StreamGroup<List<Post>>();
    updateStreamGroup(followingPostStreamGroup);
    await for (var change in followingPostStreamGroup.stream) {
      yield change;
    }
  }

  static Future<List<Follow>> getFollower(String uid) async {
    var res = await _firestore
        .collection('follow')
        .doc(uid)
        .collection('follower')
        .get();
    return res.docs.map((e) => Follow.fromJson(e.data())).toList();
  }

  static Future<List<Follow>> getFollowing(String uid) async {
    var res = await _firestore
        .collection('follow')
        .doc(uid)
        .collection('following')
        .get();
    return res.docs.map((e) => Follow.fromJson(e.data())).toList();
  }

  static Future followUser(RunningUser user) async {
    try {
      await _firestore
          .collection('follow')
          .doc(auth.currentUser.uid)
          .collection('following')
          .doc(user.userID)
          .set(Follow(
            uid: user.userID,
          ).toJson());
      await _firestore
          .collection('follow')
          .doc(user.userID)
          .collection('follower')
          .doc(auth.currentUser.uid)
          .set(Follow(
            uid: auth.currentUser.uid,
          ).toJson());
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Future unfollowUser(String uid) async {
    await _firestore
        .collection('follow')
        .doc(auth.currentUser.uid)
        .collection('following')
        .doc(uid)
        .delete();
    await _firestore
        .collection('follow')
        .doc(uid)
        .collection('follower')
        .doc(auth.currentUser.uid)
        .delete();
  }

  static Future<bool> checkFollow(String uid) async {
    var res = await _firestore
        .collection('follow')
        .doc(auth.currentUser.uid)
        .collection('following')
        .doc(uid)
        .get();
    return res.exists;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getFollowerStream() {
    return _firestore
        .collection('follow')
        .doc(auth.currentUser.uid)
        .collection('follower')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getFollowingStream() {
    return _firestore
        .collection('follow')
        .doc(auth.currentUser.uid)
        .collection('following')
        .snapshots();
  }

  static Future<List<Post>> getUserPostById(String uid) async {
    var snapshot = await _firestore
        .collection('post')
        .doc(uid)
        .collection('user_posts')
        .get();
    return snapshot.docs.map((post) => Post.fromJson(post.data())).toList();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserActivitiesStream() {
    return _firestore
        .collection('activity')
        .doc(auth.currentUser.uid)
        .collection('activities')
        .snapshots();
  }

  static Future<List<Activity>> getUserActivitiesById(String uid) async {
    var snap = await _firestore
        .collection('activity')
        .doc(uid)
        .collection('activities')
        .get();
    return snap.docs.map((e) => Activity.fromJson(e.data())).toList();
  }

  static Future<String> postFile(
      {@required File imageFile,
      @required String folderPath,
      @required String fileName}) async {
    Reference reference =
        FirebaseStorage.instance.ref().child(folderPath).child(fileName);
    TaskSnapshot storageTaskSnapshot = await reference.putFile(imageFile);

    String dowUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return dowUrl;
  }

  static Future<void> addRunningPoint(RunningUser user, int point) async {
    _firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .update({"point": user.point + point});
  }

  static Future<String> postUint8ListData(
      {@required Uint8List data,
      @required String folderPath,
      @required String fileName}) async {
    Reference reference =
        FirebaseStorage.instance.ref().child(folderPath).child(fileName);
    TaskSnapshot storageTaskSnapshot = await reference.putData(data);
    String dowUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return dowUrl;
  }

  //region facebook sign in
  static void handleFacebookSignIn() async {
    final LoginResult result = await _fbAuth
        .login(); // by default we request the email and the public profile

    if (result.status == LoginStatus.success) {
      // you are logged
      fbAccessToken = result.accessToken;
      var credential = FacebookAuthProvider.credential(fbAccessToken.token);
      await signInFirebase(credential);
    } else {
      //error
      print(result.message);
    }
  }

  //endregion
  //region google sign in

  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  static GoogleSignIn get googleSignIn => _googleSignIn;
  static void handleGoogleSignIn() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication authentication =
            await account.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken,
        );
        await signInFirebase(credential);
      }
    } catch (error) {
      print(error);
    }
  }

  static User getFirebaseUser() => FirebaseAuth.instance.currentUser;

  //endregion
  static Future signInFirebase(AuthCredential credential) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
        print(e.code);
      } else if (e.code == 'invalid-credential') {
        // handle the error here
        print(e.code);
      }
    } catch (e) {
      // handle the error here
      print(e);
    }
  }

  static Future<RunningUser> getUser() async {
    var snapshot =
        await _firestore.collection('users').doc(auth.currentUser.uid).get();
    if (snapshot.exists) {
      RunningUser result = RunningUser.fromJson(snapshot.data());
      if (result.userID == null || result.userID.isEmpty) {
        result.userID = auth.currentUser.uid;
        await upUserToFireStore(result);
      }
      return result;
    } else
      return null;
  }

  static Future<RunningUser> getUserById(String uid) async {
    var snapshot = await _firestore.collection('users').doc(uid).get();
    if (snapshot.exists)
      return RunningUser.fromJson(snapshot.data());
    else
      return null;
  }

  static Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential credential;
    String result;
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          result = 'Email không hợp lệ!';
          break;
        case 'user-not-found':
          result = 'Không tồn tại người dùng nào với email này!';
          break;
        case 'wrong-password':
          result = 'Sai mật khẩu!';
          break;
        default:
          return Future.value(e.code.toString());
          break;
      }
    }
    return Future.value(result);
  }

  static Future upUserToFireStore(RunningUser user) async {
    await _firestore.collection('users').doc(user.userID).set(user.toJson());
    _firestore
        .collection('post')
        .doc(user.userID)
        .collection('user_posts')
        .get()
        .then((post) => post.docs.forEach((element) {
              element.reference.update({
                'ownerName': user.displayName,
                'ownerAvatarUrl': user.avatarUri
              });
            }));
  }

  static Future updateUserInfo(RunningUser user) async {
    await upUserToFireStore(user);
    await auth.currentUser
        .updateProfile(displayName: user.displayName, photoURL: user.avatarUri);
  }

  static Future postComment(Post post, Comment comment) async {
    post.comment.add(comment);
    _firestore
        .collection('post')
        .doc(post.ownerID)
        .collection('user_posts')
        .doc(post.postID)
        .update({'comment': post.comment.map((v) => v.toJson()).toList()});
  }

  static Future<String> createUser(RunningUser user, String password) async {
    UserCredential credential;
    String result;
    try {
      credential = await auth.createUserWithEmailAndPassword(
          email: user.email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          result = 'Email này đã tồn tại, vui lòng chọn email khác!';
          break;
        default:
          return Future.value(e.code.toString());
          break;
      }
    }

    if (credential != null) {
      user.userID = auth.currentUser.uid;
      await updateUserInfo(user);
    }
    return Future.value(result);
  }

  static Future<String> pushActivity(Activity activity) async {
    try {
      _firestore
          .collection('activity')
          .doc(auth.currentUser.uid)
          .collection('activities')
          .doc(activity.activityID)
          .set(activity.toJson());
      return null;
    } on Exception catch (e) {
      return Future.value(e.toString());
    }
  }
}
