import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircleChart extends StatelessWidget {
  final int val;
  final double percent;

  const CircleChart({@required this.val, @required this.percent});
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 160.0,
      lineWidth: 8,
      animation: true,
      percent: percent,
      center: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
            child: Container(
          decoration: BoxDecoration(
            color: kSecondaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset('assets/images/ic_user_foot.png'),
            ),
          ),
        )),
      ),
      footer: Text(
        "${val.toString()} bước",
        style: kBigTitleTextStyle,
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: kPrimaryColor,
    );
  }
}
