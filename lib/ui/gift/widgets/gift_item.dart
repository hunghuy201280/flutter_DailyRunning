import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/model/gift/gift.dart';
import 'package:flutter_daily_running_admin/repository/running_repo.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
import 'package:shimmer/shimmer.dart';

class GiftItem extends StatelessWidget {
  final Gift data;

  const GiftItem({@required this.data});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) async {
        bool res = false;
        res = await CoolAlert.show(
          context: context,
          type: CoolAlertType.confirm,
          backgroundColor: Colors.white,
          title: "Xóa quà tặng",
          confirmBtnColor: kPrimaryColor,
          width: 50,
          text: "Bạn có muốn xóa quà tặng này ?",
          barrierDismissible: false,
          onConfirmBtnTap: () {
            Navigator.pop(context, true);
          },
          confirmBtnText: "Có",
          cancelBtnText: "Không",
          onCancelBtnTap: () => Navigator.pop(context, false),
        );
        return res;
      },
      onDismissed: (direction) {
        RunningRepo.deleteGift(data);
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 32,
        ),
      ),
      key: ObjectKey(data),
      child: Card(
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
      ),
    );
  }
}
