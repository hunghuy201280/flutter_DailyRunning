import 'package:flutter/cupertino.dart';
import 'package:flutter_daily_running_admin/repository/running_repo.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginViewModel extends ChangeNotifier {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordFocusNode = FocusNode();
  var crPassController = TextEditingController();
  var newPassController = TextEditingController();
  var newPassRetypeController = TextEditingController();
  bool _isLoading = false;

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void reset() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    crPassController = TextEditingController();
    newPassController = TextEditingController();
    newPassRetypeController = TextEditingController();
    passwordFocusNode = FocusNode();
  }

  Future<String> onChangePasswordClick() async {
    isLoading = true;
    String crPass = crPassController.text;
    String newPass = newPassController.text;
    String newPassRetype = newPassRetypeController.text;
    if (crPass.isEmpty || newPass.isEmpty || newPassRetype.isEmpty)
      return "Vui lòng nhập đầy đủ thông tin";
    if (!kPasswordRegex.hasMatch(newPass)) return "Mật khẩu mới không hợp lệ";
    if (newPass != newPassRetype) return "Mật khẩu mới không trùng khớp";
    if (newPass == crPass) return "Mật khẩu mới không được trùng mật khẩu cũ";
    String res = await RunningRepo.changePassword(newPass, crPass);
    isLoading = false;
    return res;
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
