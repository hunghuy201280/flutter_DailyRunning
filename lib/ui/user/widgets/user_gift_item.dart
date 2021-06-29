import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/model/user/gift/gift.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserGiftItem extends StatelessWidget {
  final Gift data;

  const UserGiftItem({@required this.data});
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {},
      child: SizedBox.fromSize(
        size: Size(150, 200),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: kConcreteColor,
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: data.photoUri,
                imageBuilder: (context, imageProvider) => SizedBox.fromSize(
                  size: Size(150, 130),
                  child: Image(
                    image: imageProvider,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                placeholder: (context, _) => Shimmer.fromColors(
                  child: Container(
                    height: 130,
                    width: 150,
                    color: Colors.red,
                  ),
                  baseColor: kSecondaryColor,
                  highlightColor: Colors.grey[100],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              data.providerName,
                              style: kTitleTextStyle.copyWith(
                                color: kDoveGrayColor,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              data.giftDetail,
                              style: kTitleTextStyle.copyWith(
                                color: kMineShaftColor,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  data.point.toString(),
                                  style: kTitleTextStyle.copyWith(
                                    color: kGoldenBellColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              color: kColonialWhiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            Text(
                              'RUNNING',
                              style: kTitleTextStyle.copyWith(
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
