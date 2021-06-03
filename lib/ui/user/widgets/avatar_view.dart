import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AvatarView extends StatelessWidget {
  final ImageProvider image;
  final Function onCameraTap;

  const AvatarView({@required this.image, @required this.onCameraTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          backgroundImage: image,
          radius: 35,
        ),
        Positioned.fill(
          bottom: -13,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.circle,
              color: kConcreteColor,
              child: InkWell(
                onTap: onCameraTap,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Ink(
                    width: 18,
                    height: 18,
                    child: SvgPicture.asset(
                      'assets/images/ic_camera.svg',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
