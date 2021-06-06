import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CustomRoundedLoadingButton extends StatelessWidget {
  final String text;
  final RoundedLoadingButtonController controller;
  final void Function() onPress;
  final double horizontalPadding;
  const CustomRoundedLoadingButton(
      {@required this.text,
      @required this.onPress,
      @required this.controller,
      this.horizontalPadding = 0});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 18),
      child: RoundedLoadingButton(
        controller: controller,
        onPressed: onPress,
        successColor: kPrimaryColor,
        height: 46,
        width: 9999,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'RobotoRegular',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        color: kPrimaryColor,
      ),
    );
  }
}
