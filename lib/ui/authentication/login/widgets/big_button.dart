import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final String text;
  final Function onClick;
  final double horizontalPadding;

  const BigButton(
      {@required this.text,
      @required this.onClick,
      @required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 18, horizontal: horizontalPadding),
      child: ElevatedButton(
        onPressed: onClick,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'RobotoRegular',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 46),
          primary: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}
