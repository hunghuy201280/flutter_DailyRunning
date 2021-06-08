import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell/widget.dart';

class GiftFrontWidget extends StatelessWidget {
  const GiftFrontWidget({
    Key key,
    @required GlobalKey<SimpleFoldingCellState> foldingCellKey,
  })  : _foldingCellKey = foldingCellKey,
        super(key: key);

  final GlobalKey<SimpleFoldingCellState> _foldingCellKey;

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
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.red,
                  child: SizedBox.fromSize(
                    size: Size(80, 80),
                    child: Image.asset(
                      'assets/images/drip_doge.png',
                      fit: BoxFit.fitHeight,
                    ),
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
                        'Tên nhà cung cấp Tên nhà cung cấp Tên nhà cung cấp Tên nhà cung cấp ',
                        style: kRoboto500TextStyle.copyWith(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Chi tiết ưu đãi Chi tiết ưu đãi Chi tiết ưu đãi Chi tiết ưu đãi Chi tiết ưu đãi ',
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
                    '599',
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
