import 'package:cool_alert/cool_alert.dart';
import 'package:daily_running/model/login/login_view_model.dart';
import 'package:daily_running/ui/authentication/register/register_screen.dart';
import 'package:daily_running/ui/authentication/register/widgets/custom_rounded_loading_button.dart';
import 'package:daily_running/ui/home/main_screen.dart';
import 'package:daily_running/utils/running_icons.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'widgets/big_button.dart';
import 'widgets/login_text_field.dart';
import 'widgets/login_with_button.dart';

class LoginScreen extends StatelessWidget {
  static String id = 'LoginScreen';
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
                SizedBox(
                  height: 10,
                ),
                LoginTextField(
                  inputType: TextInputType.emailAddress,
                  textController:
                      Provider.of<LoginViewModel>(context, listen: false)
                          .emailController,
                  label: 'Email',
                  preIcon: RunningIcons.profile,
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
                  preIcon: RunningIcons.lock,
                  isPassword: true,
                  focusNode: Provider.of<LoginViewModel>(context, listen: false)
                      .passwordFocusNode,
                  validator: Provider.of<LoginViewModel>(context, listen: false)
                      .passwordValidator,
                ),
                CustomRoundedLoadingButton(
                  text: 'Đăng nhập',
                  onPress: () {
                    //login click
                    Provider.of<LoginViewModel>(context, listen: false)
                        .loginWithEmailAndPassword((message) {
                      if (message != null)
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            text: 'Đăng nhập thất bại!\nLỗi: $message',
                            onConfirmBtnTap: () {
                              Provider.of<LoginViewModel>(context,
                                      listen: false)
                                  .loginButtonController
                                  .reset();
                              Navigator.of(context).pop();
                            });
                    });
                  },
                  controller:
                      Provider.of<LoginViewModel>(context, listen: false)
                          .loginButtonController,
                  horizontalPadding: 30,
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
                              //register click
                              Navigator.pushNamed(context, RegisterScreen.id);
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
                  onPress: () {
                    //TODO google login click
                    Provider.of<LoginViewModel>(context, listen: false)
                        .onGoogleLoginClick();
                  },
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
                  onPress: () {
                    //TODO fb login click
                    Provider.of<LoginViewModel>(context, listen: false)
                        .onFacebookSignInClick();
                  },
                ),
                SizedBox(
                  height: 24,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
