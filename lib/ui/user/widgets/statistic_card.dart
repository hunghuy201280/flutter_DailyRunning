import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final String distance;
  final String timeWorking;
  final String workingCount;

  const StatisticCard(
      {@required this.distance,
      @required this.timeWorking,
      @required this.workingCount});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(width: 1, color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatisticRow(
              title: 'Quãng đường',
              value: distance,
            ),
            StatisticRow(
              title: 'Thời gian hoạt động',
              value: timeWorking,
            ),
            StatisticRow(
              title: 'Số hoạt động',
              value: workingCount,
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticRow extends StatelessWidget {
  final String title;
  final String value;

  const StatisticRow({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kTitleTextStyle,
        ),
        Text(
          value,
          style: kTitleTextStyle.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
