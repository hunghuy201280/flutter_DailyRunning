import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/model/gift/gift_view_model.dart';
import 'package:flutter_daily_running_admin/ui/gift/widgets/gift_image_pick_dialog.dart';
import 'package:flutter_daily_running_admin/ui/login/first_screen.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'custom_text_field.dart';

class EditBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: Provider.of<GiftViewModel>(context).isLoading,
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: Container(
          height: size.height * 0.9,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Provider.of<GiftViewModel>(context).isNewGift
                            ? (Provider.of<GiftViewModel>(context).image == null
                                ? Image.asset(
                                    "assets/images/gift_place_holder.png",
                                    fit: BoxFit.fitHeight,
                                  )
                                : SizedBox.fromSize(
                                    size: Size(120, 120),
                                    child: Image.file(
                                      Provider.of<GiftViewModel>(context).image,
                                      height: 120,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ))
                            : (Provider.of<GiftViewModel>(context).image == null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        Provider.of<GiftViewModel>(context)
                                            .selectedGift
                                            .photoUri,
                                    imageBuilder: (context, imageProvider) =>
                                        SizedBox.fromSize(
                                      size: Size(120, 120),
                                      child: Image(
                                        image: imageProvider,
                                        height: 120,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    placeholder: (context, _) =>
                                        Shimmer.fromColors(
                                      child: Container(
                                        height: 120,
                                        width: 120,
                                      ),
                                      baseColor: kSecondaryColor,
                                      highlightColor: Colors.grey[100],
                                    ),
                                  )
                                : SizedBox.fromSize(
                                    size: Size(120, 120),
                                    child: Image.file(
                                      Provider.of<GiftViewModel>(context).image,
                                      height: 120,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )),
                      ),
                      Positioned.fill(
                        bottom: -10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Material(
                            type: MaterialType.circle,
                            color: kConcreteColor,
                            child: InkWell(
                              customBorder: CircleBorder(),
                              onTap: () async {
                                ImageSource source = await showDialog(
                                  context: context,
                                  builder: (context) => GiftPickImageDialog(),
                                );
                                if (source == null) return;
                                Provider.of<GiftViewModel>(context,
                                        listen: false)
                                    .onGiftImagePick(source);
                              },
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CustomTextField(
                      onFieldSubmitted: (text) {
                        Provider.of<GiftViewModel>(context, listen: false)
                            .detailFocusNode
                            .requestFocus();
                      },
                      label: "Tên nhà cung cấp",
                      focusNode:
                          Provider.of<GiftViewModel>(context).providerFocusNode,
                      controller: Provider.of<GiftViewModel>(context)
                          .providerController,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller:
                          Provider.of<GiftViewModel>(context).detailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      focusNode:
                          Provider.of<GiftViewModel>(context).detailFocusNode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        labelText: "Chi tiết quà tặng",
                        labelStyle: TextStyle(
                          color: Provider.of<GiftViewModel>(context)
                                  .detailFocusNode
                                  .hasFocus
                              ? kPrimaryColor
                              : Colors.black54,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              Provider.of<GiftViewModel>(context, listen: false)
                                  .detailController
                                  .clear(),
                          iconSize: 20,
                          icon: Icon(
                            FontAwesomeIcons.timesCircle,
                            color: Provider.of<GiftViewModel>(context)
                                    .detailFocusNode
                                    .hasFocus
                                ? kPrimaryColor
                                : Colors.black54,
                          ),
                        ),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    'assets/images/ic_running_point.png',
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    width: 100,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      focusNode:
                          Provider.of<GiftViewModel>(context, listen: false)
                              .pointFocusNode,
                      controller:
                          Provider.of<GiftViewModel>(context).pointController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      if (Provider.of<GiftViewModel>(context, listen: false)
                          .isNewGift)
                        Provider.of<GiftViewModel>(context, listen: false)
                            .onAddGift((res) {
                          if (res != null) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: 'Thêm quà thất bại!\nLỗi: $res',
                            );
                          } else {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              text: 'Thêm quà thành công!',
                              onConfirmBtnTap: () => Navigator.popUntil(
                                  context, ModalRoute.withName(FirstScreen.id)),
                              barrierDismissible: false,
                            );
                          }
                        });
                      else
                        Provider.of<GiftViewModel>(context, listen: false)
                            .onUpdateGift((res) {
                          if (res != null) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: 'Chỉnh sửa quà thất bại!\nLỗi: $res',
                            );
                          } else {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              text: 'Chỉnh sửa quà thành công!',
                              barrierDismissible: false,
                              onConfirmBtnTap: () => Navigator.pop(context),
                            );
                          }
                        });
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'XÁC NHẬN',
                        style: kRoboto500TextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      padding: EdgeInsets.zero,
                      backgroundColor: kActiveTabbarColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
