import 'dart:ui';

import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BlurLoading extends StatelessWidget {
  final bool isLoading;

  const BlurLoading({@required this.isLoading});
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: SpinKitCubeGrid(
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
