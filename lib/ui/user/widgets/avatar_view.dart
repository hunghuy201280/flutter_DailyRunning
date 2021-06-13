import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class AvatarView extends StatelessWidget {
  final String imageUrl;
  final Function onCameraTap;

  const AvatarView({@required this.imageUrl, @required this.onCameraTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
            radius: 35,
          ),
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: kSecondaryColor,
            highlightColor: Colors.grey[100],
            child: CircleAvatar(
              radius: 35,
            ),
          ),
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
