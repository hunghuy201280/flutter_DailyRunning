import 'package:daily_running/utils/app_icon.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'widgets/login_text_field.dart';
import 'widgets/login_with_button.dart';

class LoginScreen extends StatelessWidget {
  static String id = 'LoginScreen';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/login_banner.jpg',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Text(
                'DailyRunning',
                style: TextStyle(
                  fontFamily: 'SpringBlueVinyl',
                  fontSize: 36,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              LoginTextField(
                usernameController: usernameController,
                hint: 'Tài khoản',
                preIcon: FontAwesomeIcons.user,
              ),
              LoginTextField(
                usernameController: passwordController,
                hint: 'Mật khẩu',
                preIcon: Icons.lock_outline_rounded,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                    //TODO: login click
                  },
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontFamily: 'RobotoRegular',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 46),
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                    text: 'Bạn chưa có tài khoản ? ',
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
                        text: 'Đăng ký',
                        style: TextStyle(
                          fontSize: 15,
                          color: kPrimaryColor,
                          fontFamily: 'RobotoRegular',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Divider(
                        color: Colors.black54,
                        thickness: 1,
                      ),
                    ),
                    Text(
                      '    Hoặc    ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Divider(
                        color: Colors.black54,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              LoginWithButton(
                icon: FontAwesomeIcons.google,
                iconColor: Colors.red,
                text: 'Sign in with Google',
                isOutLine: true,
                textColor: Colors.black54,
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              LoginWithButton(
                icon: FontAwesomeIcons.facebook,
                iconColor: Colors.white,
                text: 'Login with Facebook',
                isOutLine: false,
                textColor: Colors.white,
                color: kFacebookColor,
              ),
              SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}