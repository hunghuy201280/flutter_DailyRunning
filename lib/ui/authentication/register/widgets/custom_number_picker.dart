import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomNumberPicker extends StatelessWidget {
  final int value;
  final Function onValueChanged;
  final String title;
  final int minValue;
  final int maxValue;

  const CustomNumberPicker({
    @required this.value,
    @required this.onValueChanged,
    @required this.title,
    @required this.minValue,
    @required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kSmallTitleTextStyle,
          ),
          Center(
            child: NumberPicker(
              axis: Axis.horizontal,
              maxValue: maxValue,
              onChanged: onValueChanged,
              minValue: minValue,
              value: value,
            ),
          ),
        ],
      ),
    );
  }
}
