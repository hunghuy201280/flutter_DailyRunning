import 'package:daily_running/model/user/update_info_view_model.dart';
import 'package:daily_running/ui/authentication/register/widgets/custom_number_picker.dart';
import 'package:daily_running/ui/authentication/register/widgets/custom_rounded_loading_button.dart';
import 'package:daily_running/ui/authentication/register/widgets/date_picker.dart';
import 'package:daily_running/ui/authentication/register/widgets/rounded_rect_radio.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: UpdateInfoTextFormField(
                    controller: Provider.of<UpdateInfoViewModel>(context)
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
                      false,
                      'Nam',
                    ),
                    RadioModel(
                      true,
                      'Nữ',
                    ),
                  ],
                  onCheckedChange: (val) {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: DatePicker(
                    date: '07/06/2021',
                    tapCallback: () {
                      //TODO open date picker
                    },
                  ),
                ),
                CustomNumberPicker(
                  value: 150,
                  title: 'Chiều cao (cm)',
                  onValueChanged: (int) {},
                  minValue: 130,
                  maxValue: 220,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomNumberPicker(
                  value: 50,
                  title: 'Cân nặng (kg)',
                  onValueChanged: (int) {},
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
                  controller: RoundedLoadingButtonController(),
                  text: 'Cập nhật thông tin',
                  onPress: () {},
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
