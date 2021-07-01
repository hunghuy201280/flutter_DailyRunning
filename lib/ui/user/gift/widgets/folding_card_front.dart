import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_running/model/user/gift/gift.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:shimmer/shimmer.dart';

class GiftFrontWidget extends StatelessWidget {
  const GiftFrontWidget({
    Key key,
    @required GlobalKey<SimpleFoldingCellState> foldingCellKey,
    @required this.data,
  })  : _foldingCellKey = foldingCellKey,
        super(key: key);

  final GlobalKey<SimpleFoldingCellState> _foldingCellKey;
  final Gift data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _foldingCellKey.currentState.toggleFold(),
      child: Card(
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 2,
            color: kPrimaryColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                      fit: BoxFit.cover,
                    ),
                  ),
                  placeholder: (context, _) => Shimmer.fromColors(
                    child: Container(
                      height: 80,
                      width: 80,
                      color: Colors.red,
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
      ),
    );
  }
}
