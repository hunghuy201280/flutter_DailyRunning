import 'package:daily_running/ui/user/gift/widgets/folding_card_front.dart';
import 'package:daily_running/ui/user/gift/widgets/folding_card_inner.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';

class GiftScreen extends StatelessWidget {
  static final id = 'GiftScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Đổi quà',
            style: kBigTitleTextStyle,
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return GiftFoldingCell();
          },
          itemCount: 10,
        ),
      ),
    );
  }
}

class GiftFoldingCell extends StatelessWidget {
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SimpleFoldingCell.create(
          key: _foldingCellKey,
          cellSize: Size(MediaQuery.of(context).size.width - 70, 120),
          frontWidget: GiftFrontWidget(foldingCellKey: _foldingCellKey),
          innerWidget: GiftInnerWidget(foldingCellKey: _foldingCellKey)),
    );
  }
}
