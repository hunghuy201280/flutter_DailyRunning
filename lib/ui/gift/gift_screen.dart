import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/model/gift/gift_view_model.dart';
import 'package:flutter_daily_running_admin/ui/gift/widgets/custom_text_field.dart';
import 'package:flutter_daily_running_admin/ui/gift/widgets/edit_bottom_sheet.dart';
import 'package:flutter_daily_running_admin/ui/gift/widgets/gift_item.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class GiftScreen extends StatelessWidget {
  static String id = 'GiftScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Danh sách quà",
          style: kBigTitleTextStyle,
        ),
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<GiftViewModel>(context, listen: false).onAddClick();
          showModalBottomSheet(
            barrierColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) => EditBottomSheet(),
          );
        },
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.add_outlined,
          color: Colors.black,
          size: 40,
        ),
      ),
      body: Center(
        child: Container(
          width: 350,
          child: ListView.builder(
            itemBuilder: (context, index) => GestureDetector(
                child: Padding(
                  padding: index !=
                          (Provider.of<GiftViewModel>(context).gifts.length - 1)
                      ? EdgeInsets.only(bottom: 16)
                      : EdgeInsets.only(bottom: 80),
                  child: GiftItem(
                    data: Provider.of<GiftViewModel>(context).gifts[index],
                  ),
                ),
                onTap: () {
                  Provider.of<GiftViewModel>(context, listen: false)
                      .onEditClick(
                          Provider.of<GiftViewModel>(context, listen: false)
                              .gifts[index]);
                  showModalBottomSheet(
                    barrierColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => EditBottomSheet(),
                  );
                }),
            itemCount: Provider.of<GiftViewModel>(context).gifts.length,
          ),
        ),
      ),
    ));
  }
}
