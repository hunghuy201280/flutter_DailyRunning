import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/model/gift/gift.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
import 'package:shimmer/shimmer.dart';

class GiftItem extends StatelessWidget {
  final Gift data;

  const GiftItem({@required this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          width: 1,
          color: kPrimaryColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: data.photoUri,
                imageBuilder: (context, imageProvider) => SizedBox.fromSize(
                  size: Size(80, 80),
                  child: Image(
                    image: imageProvider,
                    height: 80,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                placeholder: (context, _) => Shimmer.fromColors(
                  child: Container(
                    height: 80,
                    width: 80,
                  ),
                  baseColor: kSecondaryColor,
                  highlightColor: Colors.grey[100],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.providerName,
                      style: kRoboto500TextStyle.copyWith(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      data.giftDetail,
                      style: kRoboto500TextStyle.copyWith(
                        color: kMineShaftColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ic_running_point.png',
                  height: 32,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  data.point.toString(),
                  style: kRoboto500TextStyle.copyWith(
                    color: kMineShaftColor,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
