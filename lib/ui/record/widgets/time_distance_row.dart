import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class TimeDistanceRow extends StatelessWidget {
  final String time;
  final String distance;
  final String velocity;

  const TimeDistanceRow(
      {@required this.time, @required this.distance, @required this.velocity});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              'Tổng thời gian',
              style: kAvo400TextStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              time,
              style: kAvo400TextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
        Column(
          children: [
            Text(
              'Vận tốc',
              style: kAvo400TextStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              velocity,
              style: kAvo400TextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
        Column(
          children: [
            Text(
              'Quãng đường',
              style: kAvo400TextStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              distance,
              style: kAvo400TextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ],
    );
  }
}
