import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/model/gift/gift.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:async/async.dart' as FlutterAsync;

class RunningRepo {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseAuth get auth => _auth;
  static Uuid uuid = Uuid();
  static final normalDateFormat = DateFormat("dd-MM-yyyy");

  static void resetData() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _auth.signOut();
  }

  static Future setGift(Gift gift) async {
    await _firestore.collection("gift").doc(gift.iD).set(gift.toJson());
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

  static Stream<List<Gift>> getGiftStream() async* {
    var stream = _firestore.collection("gift").snapshots();
    await for (var data in stream) {
      yield data.docChanges.map((e) => Gift.fromJson(e.doc.data())).toList();
    }
  }

  static Future<bool> checkAdmin(String email) async {
    var res = await _firestore.collection("admin").doc(email).get();
    if (res.exists)
      return true;
    else
      return false;
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
}
