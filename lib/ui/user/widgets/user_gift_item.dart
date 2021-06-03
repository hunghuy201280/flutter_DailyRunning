import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class UserGiftItem extends StatelessWidget {
  final ImageProvider image;
  final String providerName;
  final String giftDetail;
  final int point;

  const UserGiftItem({
    @required this.image,
    @required this.providerName,
    @required this.giftDetail,
    @required this.point,
  });
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
              SizedBox.fromSize(
                size: Size(150, 130),
                child: Image(
                  image: image,
                  fit: BoxFit.cover,
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
                              providerName,
                              style: kTitleTextStyle.copyWith(
                                color: kDoveGrayColor,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              giftDetail,
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
                                  point.toString(),
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
