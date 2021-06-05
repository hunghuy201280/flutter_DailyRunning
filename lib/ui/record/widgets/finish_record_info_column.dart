import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class FinishRecordInfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const FinishRecordInfoColumn({
    @required this.title,
    @required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: kAvo400TextStyle.copyWith(fontSize: 13),
        ),
        Text(
          value,
          style: kBigTitleTextStyle.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}
