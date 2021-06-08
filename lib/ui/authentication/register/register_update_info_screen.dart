import 'package:cool_alert/cool_alert.dart';
import 'package:daily_running/model/login/register_view_model.dart';
import 'package:daily_running/ui/authentication/first_screen.dart';
import 'package:daily_running/ui/authentication/login/login_screen.dart';
import 'package:daily_running/ui/authentication/login/widgets/big_button.dart';
import 'package:daily_running/ui/authentication/register/widgets/custom_rounded_loading_button.dart';
import 'package:daily_running/ui/authentication/register/widgets/date_picker.dart';
import 'package:daily_running/ui/authentication/register/widgets/rounded_rect_radio.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../main.dart';
import 'widgets/custom_number_picker.dart';

class RegisterUpdateInfo extends StatelessWidget {
  RegisterUpdateInfo({this.isEmail = true});
  final bool isEmail;
  static String id = 'RegisterUpdateInfo';
  void onRegisterClick(context) {
    bool gender = Provider.of<RegisterViewModel>(context, listen: false).gender;
    if (gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          DailyRunning.createSnackBar('Vui lòng chọn giới tính!', 3));
      Provider.of<RegisterViewModel>(context, listen: false)
          .registerButtonController
          .stop();
    } else
      Provider.of<RegisterViewModel>(context, listen: false)
          .onRegisterClick(isEmail, onComplete: (message) async {
        if (message == null) {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: isEmail
                  ? 'Đăng ký thành công!'
                  : 'Cập nhật thông tin thành công!');
          Provider.of<RegisterViewModel>(context, listen: false).reset();
          await Future.delayed(
            Duration(
              seconds: 3,
            ),
          );

          Navigator.pushNamedAndRemoveUntil(
              context, FirstScreen.id, (route) => false);
        } else {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text:
                  '${isEmail ? 'Đăng ký' : 'Cập nhật thông tin'} thất bại.\nLỗi: $message');
          Provider.of<RegisterViewModel>(context, listen: false)
              .registerButtonController
              .reset();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Cập nhật thông tin',
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
                      Provider.of<RegisterViewModel>(context).gender ?? false,
                      'Nam',
                    ),
                    RadioModel(
                      !(Provider.of<RegisterViewModel>(context).gender ?? true),
                      'Nữ',
                    ),
                  ],
                  onCheckedChange:
                      Provider.of<RegisterViewModel>(context).onGenderChange,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: DatePicker(
                    date: Provider.of<RegisterViewModel>(context).getDob,
                    tapCallback: () {
                      //TODO open date picker
                      Provider.of<RegisterViewModel>(context, listen: false)
                          .selectDate(context);
                    },
                  ),
                ),
                CustomNumberPicker(
                  value: Provider.of<RegisterViewModel>(context).height,
                  title: 'Chiều cao (cm)',
                  onValueChanged:
                      Provider.of<RegisterViewModel>(context).onHeightChanged,
                  minValue: 130,
                  maxValue: 220,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomNumberPicker(
                  value: Provider.of<RegisterViewModel>(context).weight,
                  title: 'Cân nặng (kg)',
                  onValueChanged:
                      Provider.of<RegisterViewModel>(context).onWeightChanged,
                  minValue: 30,
                  maxValue: 200,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(child: kAppNameTextBlack),
                SizedBox(
                  height: 10,
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
                      Provider.of<RegisterViewModel>(context, listen: false)
                          .registerButtonController,
                  text: isEmail ? 'Đăng ký' : 'Cập nhật thông tin',
                  onPress: () {
                    onRegisterClick(context);
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
