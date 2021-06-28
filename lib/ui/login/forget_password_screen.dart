import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/model/login/login_view_model.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
import 'package:provider/provider.dart';

import 'first_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  static String id = "ForgetPasswordScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F5FC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              "assets/images/forget_password_banner.png",
              height: 250,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Quên mật khẩu?",
              style: kBigTitleTextStyle.copyWith(
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Vui lòng nhập lại địa chỉ email liên kết\n với tài khoản của bạn",
              style: kAvo400TextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 26,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox.fromSize(
                size: Size(double.infinity, 220),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: Provider.of<LoginViewModel>(context)
                              .emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: kAvo400TextStyle.copyWith(
                              color: kDoveGrayColor,
                              fontSize: 20,
                            ),
                            contentPadding: EdgeInsets.all(20),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: kSecondaryColor, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 2),
                            ),
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: kSecondaryColor, width: 1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Gửi mail",
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
                                      onTap: () {
                                        Provider.of<LoginViewModel>(context,
                                                listen: false)
                                            .onResetPasswordClick((res) {
                                          if (res == null) {
                                            CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              backgroundColor: Colors.white,
                                              title: "Gửi mail thành công",
                                              confirmBtnColor: kPrimaryColor,
                                              width: 50,
                                              onConfirmBtnTap: () {
                                                Navigator.popUntil(
                                                    context,
                                                    ModalRoute.withName(
                                                        FirstScreen.id));
                                              },
                                            );
                                          } else {
                                            CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              backgroundColor: Colors.white,
                                              title: "Gửi mail thất bại",
                                              text: "Lỗi: $res",
                                              confirmBtnColor: kPrimaryColor,
                                              width: 50,
                                            );
                                          }
                                        });
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
