import 'package:daily_running/main.dart';
import 'package:daily_running/model/login/register_view_model.dart';
import 'package:daily_running/ui/authentication/login/widgets/big_button.dart';
import 'package:daily_running/ui/authentication/register/register_update_info_screen.dart';
import 'package:daily_running/ui/authentication/register/widgets/register_text_field.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static String id = 'RegisterScreen';

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final retypePasswordFocusNode = FocusNode();
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
                  color: Color(0xffF2F5FC),
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
                            inputType: TextInputType.name,
                            textController: Provider.of<RegisterViewModel>(
                                    context,
                                    listen: false)
                                .displayNameController,
                            title: 'Tên hiển thị',
                            onFieldSubmitted: (text) =>
                                emailFocusNode.requestFocus(),
                          ),
                          RegisterTextField(
                            inputType: TextInputType.emailAddress,
                            textController: Provider.of<RegisterViewModel>(
                                    context,
                                    listen: false)
                                .emailController,
                            title: 'Email',
                            focusNode: emailFocusNode,
                            validator: Provider.of<RegisterViewModel>(context,
                                    listen: false)
                                .emailValidate,
                            onFieldSubmitted: (text) =>
                                passwordFocusNode.requestFocus(),
                          ),
                          RegisterTextField(
                            inputType: TextInputType.visiblePassword,
                            isPassword: true,
                            textController: Provider.of<RegisterViewModel>(
                                    context,
                                    listen: false)
                                .passwordController,
                            title: 'Mật khẩu',
                            focusNode: passwordFocusNode,
                            validator: Provider.of<RegisterViewModel>(context,
                                    listen: false)
                                .passwordValidate,
                            onFieldSubmitted: (text) =>
                                retypePasswordFocusNode.requestFocus(),
                          ),
                          RegisterTextField(
                            inputType: TextInputType.visiblePassword,
                            isPassword: true,
                            textController: Provider.of<RegisterViewModel>(
                                    context,
                                    listen: false)
                                .retypePasswordController,
                            title: 'Xác thực mật khẩu',
                            focusNode: retypePasswordFocusNode,
                            validator: Provider.of<RegisterViewModel>(context,
                                    listen: false)
                                .passwordRetypeValidate,
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
                              onPressed: () {
                                //todo next click
                                if (Provider.of<RegisterViewModel>(context,
                                        listen: false)
                                    .onNextClick())
                                  Navigator.pushNamed(
                                      context, RegisterUpdateInfo.id);
                                else
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      DailyRunning.createSnackBar(
                                          'Vui lòng điền đầy đủ thông tin!',
                                          3));
                              },
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
                                          //TODO: login click

                                          Navigator.pop(context);
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
