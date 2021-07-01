import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/model/login/login_view_model.dart';
import 'package:flutter_daily_running_admin/repository/running_repo.dart';
import 'package:flutter_daily_running_admin/ui/gift/gift_screen.dart';
import 'package:flutter_daily_running_admin/ui/login/forget_password_screen.dart';
import 'package:flutter_daily_running_admin/ui/login/widgets/custom_rounded_loading_button.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'widgets/big_button.dart';
import 'widgets/login_text_field.dart';
import 'widgets/login_with_button.dart';

class LoginScreen extends StatelessWidget {
  static String id = 'LoginScreen';
  final loginButtonController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<LoginViewModel>(context).isLoading,
          progressIndicator: Center(
            child: SpinKitFoldingCube(
              color: kPrimaryColor,
              size: 50,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/login_banner.jpg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                kAppNameTextBlack,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "FOR ADMIN",
                    style: kBigTitleTextStyle,
                  ),
                ),
                LoginTextField(
                  inputType: TextInputType.emailAddress,
                  textController:
                      Provider.of<LoginViewModel>(context, listen: false)
                          .emailController,
                  label: 'Email',
                  preIcon: FontAwesomeIcons.user,
                  validator: Provider.of<LoginViewModel>(context, listen: false)
                      .emailValidator,
                  onFieldSubmitted:
                      Provider.of<LoginViewModel>(context, listen: false)
                          .onEmailDone,
                ),
                LoginTextField(
                  textController:
                      Provider.of<LoginViewModel>(context, listen: false)
                          .passwordController,
                  label: 'Mật khẩu',
                  preIcon: FontAwesomeIcons.lock,
                  isPassword: true,
                  focusNode: Provider.of<LoginViewModel>(context, listen: false)
                      .passwordFocusNode,
                  validator: Provider.of<LoginViewModel>(context, listen: false)
                      .passwordValidator,
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, ForgetPasswordScreen.id);
                        },
                      text: 'Quên mật khẩu ?',
                      style: TextStyle(
                        fontSize: 15,
                        color: kPrimaryColor,
                        fontFamily: 'RobotoRegular',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ]),
                ),
                CustomRoundedLoadingButton(
                  text: 'Đăng nhập',
                  onPress: () {
                    //login click
                    Provider.of<LoginViewModel>(context, listen: false)
                        .loginWithEmailAndPassword((message) async {
                      if (message != null) {
                        loginButtonController.error();

                        await CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          text: 'Đăng nhập thất bại!\nLỗi: $message',
                        );
                        loginButtonController.reset();
                      }
                    });
                  },
                  controller: loginButtonController,
                  horizontalPadding: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
