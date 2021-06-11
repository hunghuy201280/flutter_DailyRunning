import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordButtonRow extends StatelessWidget {
  final Function onStopPress;
  final Function onPausePress;
  final Function onContinuePress;

  const RecordButtonRow(
      {@required this.onStopPress,
      @required this.onPausePress,
      @required this.onContinuePress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: Provider.of<RecordViewModel>(context).isPause,
            child: Padding(
              padding: const EdgeInsets.only(right: 35),
              child: SizedBox.fromSize(
                size: Size(40, 40),
                child: Container(
                  child: IconButton(
                    splashRadius: 20,
                    padding: EdgeInsets.all(0),
                    iconSize: 30,
                    splashColor: kSecondaryColor,
                    onPressed: onStopPress,
                    icon: Icon(
                      Icons.stop_rounded,
                      color: kPrimaryColor,
                    ),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kPrimaryColor),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !Provider.of<RecordViewModel>(context).isPause,
            child: IconButton(
              splashRadius: 30,
              onPressed: onPausePress,
              iconSize: 70,
              icon: Icon(
                Icons.pause_circle_filled_rounded,
                color: kPrimaryColor,
              ),
            ),
          ),
          Visibility(
            visible: Provider.of<RecordViewModel>(context).isPause,
            child: IconButton(
              splashRadius: 20,
              iconSize: 50,
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.play_circle_fill_rounded,
                color: kPrimaryColor,
              ),
              onPressed: onContinuePress,
            ),
          )
        ],
      ),
    );
  }
}
