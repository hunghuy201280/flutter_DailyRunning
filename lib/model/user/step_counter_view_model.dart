import 'dart:async';
import 'dart:io';

import 'package:daily_running/repo/running_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCounterViewModel extends ChangeNotifier {
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  StreamSubscription stepSub;
  int steps = 0;
  int lastSteps = 0;
  int target = 2000;
  void onStepCount(StepCount event) {
    if (lastSteps != 0) {
      steps += event.steps - lastSteps;
      RunningRepo.updateStep(steps);
    }
    lastSteps = event.steps;
    notifyListeners();
    DateTime timeStamp = event.timeStamp;
  }

  void onStepCountError(error) {
    /// Handle the error
    print("Error: $error");
  }

  Future<void> initPlatformState() async {
    var permis = await Permission.activityRecognition.request();
    if (permis.isDenied) {
      return;
    }
    if (stepSub != null) stepSub.cancel();
    steps = await RunningRepo.getStep();
    target = await RunningRepo.getTarget();
    _stepCountStream = Pedometer.stepCountStream;
    stepSub = _stepCountStream.listen(onStepCount);
    stepSub.onError(onStepCountError);
  }

  void onTargetSelected(int targetStep) {
    target = targetStep;
    notifyListeners();
    RunningRepo.setTarget(targetStep);
  }
}
