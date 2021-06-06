import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class RoundedRectRadio extends StatefulWidget {
  final List<RadioModel> data;
  final void Function(bool) onCheckedChange;
  RoundedRectRadio({@required this.data, @required this.onCheckedChange});
  @override
  createState() {
    return RoundedRectRadioState();
  }
}

class RoundedRectRadioState extends State<RoundedRectRadio> {
  int checkedIndex = 2;
  @override
  void initState() {
    super.initState();
    if (widget.data[0].isSelected) {
      checkedIndex = 0;
    } else if (widget.data[1].isSelected) {
      checkedIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Ink(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: RadioItem(
                text: widget.data[0].text,
                isSelected: checkedIndex == 0,
                tapCallback: () {
                  setState(() {
                    checkedIndex = 0;
                  });
                  widget.onCheckedChange(true);
                }),
          ),
        ),
        SizedBox(
          width: 40,
        ),
        Expanded(
          child: Ink(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: RadioItem(
                text: widget.data[1].text,
                isSelected: checkedIndex == 1,
                tapCallback: () {
                  setState(() {
                    checkedIndex = 1;
                  });
                  widget.onCheckedChange(false);
                }),
          ),
        ),
      ],
    );
  }
}

class RadioModel {
  final bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text);
}

class RadioItem extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Function tapCallback;

  RadioItem({
    @required this.text,
    @required this.tapCallback,
    @required this.isSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          InkWell(
            onTap: tapCallback,
            child: Ink(
              height: 18.0,
              width: 18.0,
              child: isSelected
                  ? Center(
                      child: Icon(
                      Icons.check,
                      size: 12,
                    ))
                  : SizedBox(),
              decoration: new BoxDecoration(
                color: isSelected ? kPrimaryColor : Colors.transparent,
                border: new Border.all(
                    width: 1.0,
                    color: isSelected ? Colors.blueAccent : Colors.grey),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(4.0)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoRegular'),
            ),
          )
        ],
      ),
    );
  }
}
