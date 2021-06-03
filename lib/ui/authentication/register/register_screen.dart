import 'package:daily_running/ui/authentication/login/widgets/big_button.dart';
import 'package:daily_running/ui/authentication/register/widgets/register_text_field.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static String id = 'RegisterScreen';
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                child: kAppNameTextBlack,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 100,
                decoration: BoxDecoration(
                  color: kConcreteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Tạo tài khoản',
                        style: kBigTitleTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RegisterTextField(
                            textController: displayNameController,
                            title: 'Tên hiển thị',
                          ),
                          RegisterTextField(
                            textController: emailController,
                            title: 'Email',
                          ),
                          RegisterTextField(
                            textController: passwordController,
                            title: 'Mật khẩu',
                          ),
                          RegisterTextField(
                            textController: retypePasswordController,
                            title: 'Xác thực mật khẩu',
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: kPrimaryColor,
                              ),
                              onPressed: () {},
                              child: Text('Next'),
                            ),
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Bạn đã có tài khoản ? ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: kMineShaftColor,
                                    fontFamily: 'RobotoRegular',
                                  ),
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          //TODO: register click
                                        },
                                      text: 'Đăng nhập',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: kPrimaryColor,
                                        fontFamily: 'RobotoRegular',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
