import 'package:daily_running/main.dart';
import 'package:daily_running/model/user/update_info_view_model.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/authentication/register/widgets/custom_number_picker.dart';
import 'package:daily_running/ui/authentication/register/widgets/custom_rounded_loading_button.dart';
import 'package:daily_running/ui/authentication/register/widgets/date_picker.dart';
import 'package:daily_running/ui/authentication/register/widgets/rounded_rect_radio.dart';
import 'package:daily_running/ui/user/change_password_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UpdateInfoScreen extends StatelessWidget {
  static final String id = 'UpdateInfoScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Thông tin cá nhân',
            style: kBigTitleTextStyle,
          ),
          backgroundColor: kPrimaryColor,
        ),
        backgroundColor: kConcreteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpdateInfoTextFormField(
                  label: 'Email',
                  readonly: true,
                  controller:
                      Provider.of<UpdateInfoViewModel>(context, listen: false)
                          .emailController,
                  focusNode: FocusNode(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: UpdateInfoTextFormField(
                    controller:
                        Provider.of<UpdateInfoViewModel>(context, listen: false)
                            .nameController,
                    label: 'Tên*',
                    focusNode: Provider.of<UpdateInfoViewModel>(context)
                        .displayNameFocusNode,
                    validator: (text) => null,
                  ),
                ),
                Text(
                  'Giới tính',
                  style: kTitleTextStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                RoundedRectRadio(
                  data: [
                    RadioModel(
                      Provider.of<UpdateInfoViewModel>(context)
                          .updateUser
                          .gender,
                      'Nam',
                    ),
                    RadioModel(
                      !Provider.of<UpdateInfoViewModel>(context)
                          .updateUser
                          .gender,
                      'Nữ',
                    ),
                  ],
                  onCheckedChange: (val) {
                    Provider.of<UpdateInfoViewModel>(context, listen: false)
                        .gender = val;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: DatePicker(
                    date: Provider.of<UpdateInfoViewModel>(context)
                        .updateUser
                        .dob,
                    tapCallback: () {
                      //TODO open date picker
                      Provider.of<UpdateInfoViewModel>(context, listen: false)
                          .selectDate(context);
                    },
                  ),
                ),
                CustomNumberPicker(
                  value:
                      Provider.of<UpdateInfoViewModel>(context, listen: false)
                          .updateUser
                          .height,
                  title: 'Chiều cao (cm)',
                  onValueChanged: (value) {
                    Provider.of<UpdateInfoViewModel>(context, listen: false)
                        .height = value;
                  },
                  minValue: 130,
                  maxValue: 220,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomNumberPicker(
                  value:
                      Provider.of<UpdateInfoViewModel>(context, listen: false)
                          .updateUser
                          .weight,
                  title: 'Cân nặng (kg)',
                  onValueChanged: (value) {
                    Provider.of<UpdateInfoViewModel>(context, listen: false)
                        .weight = value;
                  },
                  minValue: 30,
                  maxValue: 200,
                ),
                Visibility(
                  visible: RunningRepo.isEmail(),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: GestureDetector(
                        onTap: () {
                          //TODO nav to change pass
                          Navigator.pushNamed(context, ChangePasswordScreen.id);
                        },
                        child: Text(
                          "Đổi mật khẩu",
                          style: TextStyle(
                            fontSize: 18,
                            color: kPrimaryColor,
                            fontFamily: 'RobotoRegular',
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Center(child: kAppNameTextBlack),
                ),
                Center(
                  child: Text(
                    'Phiên bản 2.2.1',
                    style: kTitleTextStyle.copyWith(
                      color: Color(0xff666666),
                    ),
                  ),
                ),
                CustomRoundedLoadingButton(
                  controller:
                      Provider.of<UpdateInfoViewModel>(context, listen: false)
                          .buttonController,
                  text: 'Cập nhật thông tin',
                  onPress: () async {
                    await Provider.of<UpdateInfoViewModel>(context,
                            listen: false)
                        .onUpdateClick((result) async {
                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            DailyRunning.createSnackBar(result, 2));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            DailyRunning.createSnackBar(
                                'Cập nhật thông tin thành công', 1));
                        Provider.of<UserViewModel>(context, listen: false)
                            .currentUser = Provider.of<UpdateInfoViewModel>(
                                context,
                                listen: false)
                            .updateUser;
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pop(context);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateInfoTextFormField extends StatelessWidget {
  final bool readonly;
  final String label;
  final String Function(String) validator;
  final FocusNode focusNode;
  final TextEditingController controller;
  const UpdateInfoTextFormField(
      {this.readonly = false,
      @required this.label,
      this.validator,
      @required this.focusNode,
      @required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: readonly,
      validator: validator,
      textAlign: TextAlign.center,
      focusNode: focusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: label,
        labelStyle: TextStyle(
          color: focusNode.hasFocus ? kPrimaryColor : Colors.black54,
        ),
        suffixIcon: !readonly
            ? IconButton(
                onPressed: () => controller.clear(),
                iconSize: 20,
                icon: Icon(
                  FontAwesomeIcons.timesCircle,
                  color: focusNode.hasFocus ? kPrimaryColor : Colors.black54,
                ),
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
