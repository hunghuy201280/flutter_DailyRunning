import 'package:daily_running/ui/authentication/login/widgets/big_button.dart';
import 'package:daily_running/ui/user/widgets/medal_item.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class GiftDetailDialog extends StatelessWidget {
  final MedalItem data;

  const GiftDetailDialog({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 250,
        width: 300,
        padding: EdgeInsets.only(top: 24, left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: data.image,
                  height: 50,
                ),
                Expanded(
                  child: Text(
                    data.name,
                    style: kTitleTextStyle.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Text(
              data.detail,
              style: kRoboto500TextStyle.copyWith(
                color: Colors.black,
              ),
            ),
            BigButton(
                text: "Xác nhận",
                onClick: () => Navigator.pop(context),
                horizontalPadding: 30),
          ],
        ),
      ),
    );
  }
}
