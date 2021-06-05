import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class SmollButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final Color backgroundColor;
  final Color textColor;
  SmollButton(
      {@required this.text,
      @required this.onPress,
      @required this.backgroundColor,
      @required this.textColor});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        minimumSize: Size(130, 46),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: kRoboto500TextStyle.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
