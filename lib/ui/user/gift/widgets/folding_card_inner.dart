import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:daily_running/model/user/gift/gift.dart';
import 'package:daily_running/model/user/gift/gift_view_model.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class GiftInnerWidget extends StatelessWidget {
  const GiftInnerWidget({
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
            width: 1,
            color: kPrimaryColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: data.photoUri,
                      imageBuilder: (context, imageProvider) =>
                          SizedBox.fromSize(
                        size: Size(100, 100),
                        child: Image(
                          image: imageProvider,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      placeholder: (context, _) => Shimmer.fromColors(
                        child: Container(
                          height: 100,
                          width: 100,
                          color: Colors.red,
                        ),
                        baseColor: kSecondaryColor,
                        highlightColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data.providerName,
                            style: kRoboto500TextStyle.copyWith(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/images/ic_running_point.png',
                            height: 35,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            data.point.toString(),
                            style: kRoboto500TextStyle.copyWith(
                              color: kMineShaftColor,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
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
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              OutlinedButton(
                onPressed: () async {
                  String res =
                      await Provider.of<GiftViewModel>(context, listen: false)
                          .onExchangeClick(data);
                  if (res == null) {
                    Provider.of<UserViewModel>(context, listen: false)
                        .exchangeGift(data.point);
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      backgroundColor: Colors.white,
                      title: "Đổi quà thành công",
                      confirmBtnColor: kPrimaryColor,
                      width: 50,
                      text:
                          "Còn lại ${Provider.of<UserViewModel>(context, listen: false).currentUser.point} điểm Running",
                      barrierDismissible: false,
                    );
                  } else {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      backgroundColor: Colors.white,
                      title: "Đổi quà thất bại",
                      confirmBtnColor: kPrimaryColor,
                      width: 50,
                      text: res,
                      barrierDismissible: false,
                    );
                  }
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'ĐỔI NGAY',
                    style: kRoboto500TextStyle.copyWith(
                      color: kMineShaftColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: kActiveTabbarColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
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
