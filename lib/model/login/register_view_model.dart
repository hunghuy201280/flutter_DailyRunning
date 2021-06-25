import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/authentication/register/register_update_info_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterViewModel extends ChangeNotifier {
  var displayNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var retypePasswordController = TextEditingController();
  var registerButtonController = RoundedLoadingButtonController();
  int height = 150;
  int weight = 50;
  DateTime dob = DateTime.now().subtract(Duration(days: 2000));
  static final dateFormat = DateFormat("dd/MM/yyyy");
  bool gender; //true=nam false = nu

  void reset() {
    displayNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    retypePasswordController = TextEditingController();
    registerButtonController = RoundedLoadingButtonController();
    height = 150;
    weight = 50;
    dob = DateTime.now().subtract(Duration(days: 2000));
    gender = null;
  }

  get getDob {
    return dateFormat.format(dob).toString();
  }

  void onGenderChange(bool value) {
    gender = value;
    notifyListeners();
  }

  String emailValidate(String email) {
    if (!kEmailRegex.hasMatch(email)) return 'Email không hợp lệ';
    return null;
  }

  String passwordValidate(String password) {
    if (!kPasswordRegex.hasMatch(password)) return 'Mật khẩu không hợp lệ';
    return null;
  }

  String passwordRetypeValidate(String retypePassword) {
    if (passwordController.text != retypePassword)
      return 'Mật khẩu không trùng khớp';
    return null;
  }

  void onHeightChanged(int value) {
    height = value;
    notifyListeners();
  }

  void onWeightChanged(int value) {
    weight = value;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        locale: Locale('vi', 'VN'),
        context: context,
        initialDate: dob,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now().subtract(Duration(days: 2000)));
    if (picked == null) return;
    dob = picked;
    notifyListeners();
  }

  void onRegisterClick(bool isEmail, {void Function(String) onComplete}) async {
    if (isEmail) {
      RunningUser user = RunningUser(
        displayName: displayNameController.text.trim(),
        email: emailController.text.trim(),
        gender: gender,
        dob: getDob,
        height: height,
        weight: weight,
        avatarUri: kDefaultAvatarUrl,
      );
      String message =
          await RunningRepo.createUser(user, passwordController.text.trim());
      if (message == null) {
        registerButtonController.success();
      }
      onComplete(message);
    } else {
      User mFirebaseUser = RunningRepo.getFirebaseUser();
      String avatarUrl = mFirebaseUser.photoURL;
      if (avatarUrl == null) {
        final userData = await RunningRepo.fbAuth.getUserData();
        avatarUrl = userData["picture"]["data"]["url"];
      }
      RunningUser user = RunningUser(
          displayName: mFirebaseUser.displayName,
          email: mFirebaseUser.email,
          gender: gender,
          dob: getDob,
          height: height,
          weight: weight,
          avatarUri: mFirebaseUser.photoURL,
          userID: mFirebaseUser.uid);
      await RunningRepo.upUserToFireStore(user);
      registerButtonController.success();
      onComplete(null);
    }
  }

  bool onNextClick() {
    if (emailController.text.isNotEmpty &&
        displayNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        retypePasswordController.text.isNotEmpty) return true;
    if (emailValidate(emailController.text) == null &&
        passwordValidate(passwordController.text) == null &&
        passwordRetypeValidate(retypePasswordController.text) == null)
      return true;
    return false;
  }
}
