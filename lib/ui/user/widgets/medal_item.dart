import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class MedalItem extends StatelessWidget {
  final ImageProvider image;
  final Function onTap;
  final String name;
  final String detail;
  const MedalItem(
      {@required this.image,
      @required this.onTap,
      @required this.name,
      @required this.detail});
  MedalItem withTap(Function tap) {
    return MedalItem(
      image: this.image,
      onTap: tap,
      name: this.name,
      detail: this.detail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Material(
        shape: CircleBorder(),
        color: kConcreteColor,
        child: InkResponse(
          onTap: onTap,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Image(
            image: image,
          ),
        ),
      ),
    );
  }
}
