import 'package:daily_running/model/login/register_view_model.dart';
import 'package:daily_running/model/user/running_user.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UpdateInfoViewModel extends ChangeNotifier {
  RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();
  FocusNode displayNameFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RunningUser updateUser;
  void setUpdateUser(RunningUser val) {
    updateUser = RunningUser.copyFrom(val);
    nameController.text = val.displayName;
    emailController.text = val.email;
  }

  set gender(val) {
    updateUser.gender = val;
    notifyListeners();
  }

  set height(val) {
    updateUser.height = val;
    notifyListeners();
  }

  set weight(val) {
    updateUser.weight = val;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        locale: Locale('vi', 'VN'),
        context: context,
        initialDate: RegisterViewModel.dateFormat.parse(updateUser.dob),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now().subtract(Duration(days: 2000)));
    if (picked == null) return;
    updateUser.dob = RegisterViewModel.dateFormat.format(picked);
    notifyListeners();
  }

  void onUpdateClick(void Function(String result) onComplete) async {
    updateUser.displayName = nameController.text;
    if (!kPersonNameRegex.hasMatch(updateUser.displayName)) {
      onComplete('Tên người dùng không hợp lệ!');
      buttonController.error();
      await Future.delayed(Duration(seconds: 2));
      buttonController.reset();

      return;
    }
    print('${updateUser.displayName}\n${updateUser.gender}'
        '\n${updateUser.dob}\n${updateUser.height}\n${updateUser.weight}');

    await RunningRepo.updateUserInfo(updateUser);
    await Future.delayed(Duration(seconds: 3));
    buttonController.success();
    onComplete(null);
  }

  UpdateInfoViewModel() {
    displayNameFocusNode.addListener(() => notifyListeners());
  }
}
