import 'package:flutter/cupertino.dart';
import 'package:flutter_daily_running_admin/repository/running_repo.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
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

  void reset() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    loginButtonController = RoundedLoadingButtonController();
  }

  void onEmailDone(text) {
    passwordFocusNode.requestFocus();
  }

  String passwordValidator(text) {
    if (!kPasswordRegex.hasMatch(text)) return 'Password không hợp lệ';
    return null;
  }

  bool get isLoading => _isLoading;

  String emailValidator(text) {
    if (!kEmailRegex.hasMatch(text)) return 'Email không hợp lệ';
    return null;
  }

  void loginWithEmailAndPassword(void Function(String) onComplete) async {
    isLoading = true;

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String result;

    if (!(kEmailRegex.hasMatch(email) && kPasswordRegex.hasMatch(password)))
      result = 'Email hoặc password không hợp lệ !';
    else {
      bool checkAdmin = await RunningRepo.checkAdmin(email);
      if (checkAdmin)
        result = await RunningRepo.signInWithEmailAndPassword(email, password);
      else
        result = "Bạn không có quyền admin";
    }
    onComplete(result);
    if (result != null) {
      loginButtonController.error();
    } else {
      loginButtonController.success();
      reset();
    }
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
