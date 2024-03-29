import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final Function tapCallback;
  final String date;
  const DatePicker({@required this.tapCallback, @required this.date});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapCallback,
      child: Ink(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ngày sinh*',
              style: kSmallTitleTextStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              date,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kEmperorColor,
                fontFamily: 'RobotoRegular',
              ),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
