import 'package:daily_running/ui/authentication/login/widgets/big_button.dart';
import 'package:daily_running/ui/authentication/register/widgets/date_picker.dart';
import 'package:daily_running/ui/authentication/register/widgets/rounded_rect_radio.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'widgets/custom_number_picker.dart';

enum Gender { Male, Female }

extension GenderExtension on Gender {
  bool get value {
    switch (this) {
      case Gender.Male:
        return true;
      case Gender.Female:
        return false;
      default:
        return null;
    }
  }
}

class RegisterUpdateInfo extends StatelessWidget {
  static String id = 'RegisterUpdateInfo';
  DateTime selectedDate = DateTime.now();
  int tempHeight = 150;
  int tempWeight = 50;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      /*setState(() {
        selectedDate = picked;
      });*/
    }
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
        body: Padding(
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
                data: [RadioModel(false, 'Nam'), RadioModel(false, 'Nữ')],
                onCheckedChange: (index) {
                  //TODO checked change
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: DatePicker(
                  tapCallback: () {
                    //TODO open date picker
                    _selectDate(context);
                  },
                ),
              ),
              CustomNumberPicker(
                value: tempHeight,
                title: 'Chiều cao (cm)',
                onValueChanged: (value) {},
                minValue: 130,
                maxValue: 220,
              ),
              SizedBox(
                height: 20,
              ),
              CustomNumberPicker(
                value: tempWeight,
                title: 'Cân nặng (kg)',
                onValueChanged: (value) {},
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
              BigButton(
                  horizontalPadding: 0,
                  text: 'Đăng ký',
                  onClick: () {
                    //TODO on register click
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
