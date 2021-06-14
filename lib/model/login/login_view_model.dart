import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginViewModel extends ChangeNotifier {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordFocusNode = FocusNode();
  var loginButtonController = RoundedLoadingButtonController();
  void reset() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    loginButtonController = RoundedLoadingButtonController();
  }

  void loginWithEmailAndPassword(void Function(String) onComplete) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String result;

    if (!(kEmailRegex.hasMatch(email) && kPasswordRegex.hasMatch(password)))
      result = 'Email hoặc password không hợp lệ !';
    else
      result = await RunningRepo.signInWithEmailAndPassword(email, password);
    onComplete(result);
    if (result != null) {
      loginButtonController.error();
    } else {
      loginButtonController.success();
      reset();
    }
  }

  String passwordValidator(text) {
    if (!kPasswordRegex.hasMatch(text)) return 'Password không hợp lệ';
    return null;
  }

  String emailValidator(text) {
    if (!kEmailRegex.hasMatch(text)) return 'Email không hợp lệ';
    return null;
  }

  void onEmailDone(text) {
    passwordFocusNode.requestFocus();
  }

  void onGoogleLoginClick() {
    RunningRepo.handleGoogleSignIn();
  }

  void onFacebookSignInClick() {
    RunningRepo.handleFacebookSignIn();
  }
}
