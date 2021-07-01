import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginViewModel extends ChangeNotifier {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordFocusNode = FocusNode();
  var loginButtonController = RoundedLoadingButtonController();
  bool _isLoading = false;

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  void reset() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    loginButtonController = RoundedLoadingButtonController();
    passwordFocusNode = FocusNode();
  }

  void loginWithEmailAndPassword(void Function(String) onComplete) async {
    isLoading = true;

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
      try {
        loginButtonController.success();
      } on Exception catch (e) {
        loginButtonController.reset();
      }
      reset();
    }
    isLoading = false;
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

  void onGoogleLoginClick() async {
    isLoading = true;
    await RunningRepo.handleGoogleSignIn();
    isLoading = false;
  }

  void onFacebookSignInClick() async {
    isLoading = true;

    await RunningRepo.handleFacebookSignIn();
    isLoading = false;
  }

  void onResetPasswordClick(void Function(String) onComplete) async {
    if (emailController.text.isEmpty) {
      onComplete("Vui lòng nhập email");
      return;
    } else if (!kEmailRegex.hasMatch(emailController.text)) {
      onComplete("Email không hợp lệ");
      return;
    }
    String res = await RunningRepo.sendResetPasswordEmail(emailController.text);
    onComplete(res);
  }
}
