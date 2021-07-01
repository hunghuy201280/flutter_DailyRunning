import 'package:cool_alert/cool_alert.dart';

import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/model/login/login_view_model.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';

import 'package:provider/provider.dart';

import '../../main.dart';

class ChangePasswordScreen extends StatelessWidget {
  static String id = "ChangePasswordScreen";

  final newPassFocusNode = FocusNode();
  final newPassRetypeFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F5FC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              "assets/images/change_password_banner.png",
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 26),
              child: Text(
                "Đổi mật khẩu",
                style: kBigTitleTextStyle.copyWith(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox.fromSize(
                size: Size(double.infinity, 300),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SimpleTextField(
                          label: "Mật khẩu cũ",
                          onSubmit: (_) => newPassFocusNode.requestFocus(),
                          focusNode: null,
                          controller: Provider.of<LoginViewModel>(context)
                              .crPassController,
                        ),
                        SimpleTextField(
                          label: "Mật khẩu mới",
                          onSubmit: (_) =>
                              newPassRetypeFocusNode.requestFocus(),
                          focusNode: newPassFocusNode,
                          controller: Provider.of<LoginViewModel>(context)
                              .newPassController,
                        ),
                        SimpleTextField(
                          label: "Xác nhận mật khẩu mới",
                          focusNode: newPassRetypeFocusNode,
                          controller: Provider.of<LoginViewModel>(context)
                              .newPassRetypeController,
                        ),
                        Divider(
                          thickness: 2,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Xác nhận",
                                style:
                                    kBigTitleTextStyle.copyWith(fontSize: 25),
                              ),
                              Container(
                                width: 70,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xff00DDAE),
                                        Color(0xff00A896),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[500],
                                        offset: Offset(0.0, 1.5),
                                        blurRadius: 1.5,
                                      ),
                                    ]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      onTap: () async {
                                        final result =
                                            await Provider.of<LoginViewModel>(
                                                    context,
                                                    listen: false)
                                                .onChangePasswordClick();

                                        if (result != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(DailyRunningAdmin
                                                  .createSnackBar(result, 2));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                                DailyRunningAdmin.createSnackBar(
                                                    "Đổi mật khẩu thành công!",
                                                    2),
                                              )
                                              .closed
                                              .then((value) {
                                            //todo logout
                                            DailyRunningAdmin.onLogoutCleanup(
                                                context);
                                          });
                                        }
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SimpleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FocusNode focusNode;
  final void Function(String) onSubmit;
  final bool isObscure;
  const SimpleTextField({
    @required this.controller,
    @required this.label,
    @required this.focusNode,
    this.onSubmit,
    this.isObscure = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      controller: controller,
      onFieldSubmitted: onSubmit,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: kAvo400TextStyle.copyWith(
          color: kDoveGrayColor,
          fontSize: 20,
        ),
        contentPadding: EdgeInsets.zero,
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
