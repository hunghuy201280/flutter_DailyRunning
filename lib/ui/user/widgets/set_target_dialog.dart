import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetTargetDialog extends StatefulWidget {
  SetTargetDialog({
    @required this.defaultValue,
  });
  final int defaultValue;
  @override
  _SetTargetDialogState createState() => _SetTargetDialogState();
}

class _SetTargetDialogState extends State<SetTargetDialog> {
  double target;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    target = widget.defaultValue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 250,
        width: 300,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      FontAwesomeIcons.walking,
                      size: 40,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Chọn mục tiêu hằng ngày của bạn',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Slider(
                      activeColor: kPrimaryColor,
                      inactiveColor: kSecondaryColor,
                      max: 20000,
                      min: 2000,
                      divisions: 100,
                      value: target,
                      onChanged: (val) {
                        setState(() {
                          target = val;
                        });
                      },
                    ),
                    Text(
                      "${target.toInt()} Bước",
                      style: kRoboto500TextStyle.copyWith(color: Colors.black),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop(target.toInt());
                      },
                      child: Text(
                        "Lưu",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
