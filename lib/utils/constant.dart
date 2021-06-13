import 'dart:ui';

import 'package:flutter/material.dart';

enum PostType { Me, Following }
const kPrimaryColor = Color(0xff00A896);
const kLightPrimaryColor = Color(0xff02C39A);
const kMineShaftColor = Color(0xff333333);
const kFacebookColor = Color(0xff4267B2);
const kConcreteColor = Color(0xffF2F2F2);
const kEmperorColor = Color(0xff505050);
const kDividerColor = Color(0xff9B9B9B);
const kDoveGrayColor = Color(0xff666666);
const kPostTextStyle = TextStyle(
  fontFamily: 'SVG Avo',
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 13,
);
const kSmallTitleTextStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: Colors.grey,
    fontFamily: 'RobotoRegular');
const kActiveTabbarColor = Color(0xffECBA67);
const kInActiveTabbarColor = Color(0xffdEDEDE);
const kSecondaryColor = Color(0xffC5F1E8);
const kColonialWhiteColor = Color(0xffFFE7BF);
const kGoldenBellColor = Color(0xffD68D15);
const kSpotifyColor = Color(0xff1DB954);

const kAppNameTextBlack = Text(
  'DailyRunning',
  style: TextStyle(
    fontFamily: 'SpringBlueVinyl',
    fontSize: 36,
  ),
);
const kAppNameTextWhite = Text(
  'DailyRunning',
  style: TextStyle(
    fontFamily: 'SpringBlueVinyl',
    color: Colors.white,
    fontSize: 36,
  ),
);
const kTitleTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: 'RobotoRegular',
    color: kMineShaftColor,
    fontSize: 14);
const kRoboto500TextStyle = TextStyle(
  color: Colors.white,
  fontSize: 17,
  fontWeight: FontWeight.w500,
  fontFamily: 'RobotoRegular',
);
const kBigTitleTextStyle = TextStyle(
  fontFamily: 'SVN Avo',
  fontWeight: FontWeight.w700,
  fontSize: 20,
);
const kAvo400TextStyle = TextStyle(
  fontFamily: 'SVN Avo',
  fontWeight: FontWeight.w400,
  fontSize: 16,
);
final kEmailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
final kPasswordRegex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$");
final kPersonNameRegex = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");
const kDefaultAvatarUrl =
    'https://firebasestorage.googleapis.com/v0/b/dailyrunning-6e8e9.appspot.com/o/avatar_photos%2Fsbcf-default-avatar%5B1%5D.png?alt=media&token=ec7c1fcd-9fc8-415f-b2ec-51ffb03867a3';
const List<Widget> kStatisticTab = [
  SizedBox(
    height: 35,
    child: Tab(
      text: 'Theo tuần',
    ),
  ),
  SizedBox(
    height: 35,
    child: Tab(
      text: 'Theo tháng',
    ),
  ),
  SizedBox(
    height: 35,
    child: Tab(
      text: 'Theo năm',
    ),
  ),
];

const kLightImage =
    'https://firebasestorage.googleapis.com/v0/b/flutter-daily-running.appspot.com/o/light_image.png?alt=media&token=24c6a8b1-d807-4c02-a545-32649d4c8b58';
