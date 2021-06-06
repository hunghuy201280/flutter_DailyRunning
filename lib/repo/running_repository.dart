import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RunningRepo {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseAuth _auth = FirebaseAuth.instance;
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
      await _firestore.collection('users').doc(user.userID).set(user.toJson());
    }
    return Future.value(result);
  }
}
