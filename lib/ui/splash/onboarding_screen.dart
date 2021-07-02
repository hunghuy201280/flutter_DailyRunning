import 'package:daily_running/ui/authentication/first_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static final id = "OnboardingScreen";

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isProgress = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/onboarding_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null /* add child content here */,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Align(
                child: kAppNameTextWhite,
                alignment: Alignment.topCenter,
              ),
            ),
            IntroductionScreen(
              pages: [
                PageViewModel(
                  title: 'Kết nối cộng đồng',
                  body:
                      'Chia sẻ quá trình của bạn và theo dõi\n quá trình của bạn bè. ',
                  image: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 90, left: 10),
                      child: Image.asset(
                        'assets/images/onboarding_1.png',
                        width: 270,
                      ),
                    ),
                  ),
                  decoration: kOnboardingPageDecoration,
                ),
                PageViewModel(
                  title: 'Theo dõi quá trình',
                  body: 'Thống kê thông số và mô phỏng lại quá trình chính xác',
                  image: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 90, left: 10),
                      child: Image.asset(
                        'assets/images/onboarding_2.png',
                        width: 320,
                      ),
                    ),
                  ),
                  decoration: kOnboardingPageDecoration,
                ),
                PageViewModel(
                  title: 'Voucher phần thưởng',
                  body:
                      'Nhiều voucher hấp dẫn theo mốc điểm hoàn toàn miễn phí ',
                  image: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 90, left: 10),
                      child: Image.asset(
                        'assets/images/onboarding_3.png',
                        width: 320,
                      ),
                    ),
                  ),
                  decoration: kOnboardingPageDecoration,
                ),
                PageViewModel(
                  title: 'Bắt đầu thôi!',
                  body: '',
                  image: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 90, left: 13),
                      child: Image.asset(
                        'assets/images/onboarding_4.png',
                        width: 100,
                      ),
                    ),
                  ),
                  decoration: kOnboardingPageDecoration.copyWith(
                    titleTextStyle: kBigTitleTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    titlePadding: EdgeInsets.only(left: 11),
                  ),
                ),
              ],
              done: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 40,
              ),
              onDone: () => Navigator.pushNamedAndRemoveUntil(
                  context, FirstScreen.id, (route) => false),
              showSkipButton: true,
              skip: Text(
                'Skip',
                style: TextStyle(color: Colors.white),
              ),
              onSkip: () => Navigator.pushNamedAndRemoveUntil(
                  context, FirstScreen.id, (route) => false),
              dotsDecorator: getDotDecoration(),
              onChange: (index) {
                if (index == 3)
                  setState(() {
                    isProgress = false;
                  });
                else
                  setState(() {
                    isProgress = true;
                  });
              },
              globalBackgroundColor: Colors.transparent,
              skipFlex: 0,
              nextFlex: 0,
              dotsFlex: 1,
              isProgress: isProgress,
              showNextButton: false,
            ),
          ],
        ),
      ),
    );
  }

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: kDoveGrayColor,
        activeColor: Colors.white,
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );
}
