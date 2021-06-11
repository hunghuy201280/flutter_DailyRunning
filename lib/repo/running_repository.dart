import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:uuid/uuid.dart';

class RunningRepo {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FacebookAuth _fbAuth = FacebookAuth.instance;
  static AccessToken fbAccessToken;
  static FacebookAuth get fbAuth => _fbAuth;
  static FirebaseAuth get auth => _auth;
  static Uuid uuid = Uuid();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserActivitiesStream() {
    return _firestore
        .collection('activity')
        .doc(_auth.currentUser.uid)
        .collection('activities')
        .snapshots();
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
        .doc(_auth.currentUser.uid)
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

  static User getFirebaseUser() => _auth.currentUser;
  //endregion
  static Future signInFirebase(AuthCredential credential) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
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
        await _firestore.collection('users').doc(_auth.currentUser.uid).get();
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
      credential = await _auth.signInWithEmailAndPassword(
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
  }

  static Future updateUserInfo(RunningUser user) async {
    await upUserToFireStore(user);
    await _auth.currentUser.updateProfile(displayName: user.displayName);
  }

  static Future<String> createUser(RunningUser user, String password) async {
    UserCredential credential;
    String result;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
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
      user.userID = credential.user.uid;
      await upUserToFireStore(user);
    }
    return Future.value(result);
  }

  static Future<String> pushActivity(Activity activity) async {
    try {
      _firestore
          .collection('activity')
          .doc(_auth.currentUser.uid)
          .collection('activities')
          .doc(activity.activityID)
          .set(activity.toJson());
      return null;
    } on Exception catch (e) {
      return Future.value(e.toString());
    }
  }
}
