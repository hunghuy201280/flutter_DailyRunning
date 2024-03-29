import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircleChart extends StatelessWidget {
  final int val;
  final int target;

  const CircleChart({@required this.val, @required this.target});
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 160.0,
      lineWidth: 8,
      animateFromLastPercent: true,
      percent: val.toDouble() / target,
      center: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
            child: Container(
          decoration: BoxDecoration(
            color: kSecondaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SizedBox.fromSize(
                size: Size(90, 90),
                child: Image.asset('assets/images/ic_user_foot.png')),
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
