import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_running/model/record/activity.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/ui/record/finish_record_screen.dart';
import 'package:daily_running/ui/user/widgets/medal_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class StatisticViewModel extends ChangeNotifier {
  List<double> distancesStatistic = [0, 0, 0];
  List<int> timeWorkingStatistic = [0, 0, 0];
  List<int> workingCountStatistic = [0, 0, 0];
  List<bool> medalAchieved = List.filled(5, false).toList();
  List<MedalItem> medals = [];

  //0= week 1= month 2= year
  Stream<QuerySnapshot<Map<String, dynamic>>> statisticStream;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  List<Activity> userActivities = [];

  void resetData() {
    distancesStatistic = [0, 0, 0];
    timeWorkingStatistic = [0, 0, 0];
    workingCountStatistic = [0, 0, 0];
    userActivities = [];
    statisticStream = null;
    medalAchieved = List.filled(5, false).toList();
    medals.clear();
  }

  void getMedal() async {
    medalAchieved = List.filled(5, false).toList();
    medals.clear();
    double distance = distancesStatistic[2];
    if (distance >= 1000) {
      medalAchieved = List.filled(5, true).toList();
    } else if (distance >= 500) {
      medalAchieved = List.filled(4, true).toList()..add(false);
    } else if (distance >= 200) {
      medalAchieved = List.filled(3, true).toList()
        ..addAll(List.filled(2, false));
    } else if (distance >= 100) {
      medalAchieved = List.filled(2, true).toList()
        ..addAll(List.filled(3, false));
    } else if (distance >= 50) {
      medalAchieved = [true]..addAll(List.filled(4, false));
    }
    for (int i = 0; i < 5; i++) {
      if (medalAchieved[i]) {
        medals.add(
          MedalItem(
            image: AssetImage('assets/images/medal_${i + 1}.png'),
            onTap: () {},
          ),
        );
      } else {
        medals.add(MedalItem(
          image: AssetImage('assets/images/medal_${i + 1}_greyscale.png'),
          onTap: () {},
        ));
      }
    }
    notifyListeners();
  }

  void getWeekStatistic() async {
    DateTime today = DateTime.now();
    var sundayOfLastWeek = today.subtract(new Duration(days: today.weekday));
    var mondayOfNextWeek = sundayOfLastWeek.add(Duration(days: 8));

    List<Activity> weekActivity = userActivities.where((act) {
      DateTime actDate = dateFormat.parse(act.dateCreated.substring(0, 10));
      return actDate.isBefore(mondayOfNextWeek) &&
          actDate.isAfter(sundayOfLastWeek);
    }).toList();
    distancesStatistic[0] = 0;
    timeWorkingStatistic[0] = 0;
    workingCountStatistic[0] = 0;
    weekActivity.forEach((act) {
      distancesStatistic[0] += act.distance;
      timeWorkingStatistic[0] += act.duration;
    });
    workingCountStatistic[0] = weekActivity.length;
    distancesStatistic[0] /= 1000;
  }

  void getMonthStatistic() {
    DateTime today = DateTime.now();
    var lastDayOfLastMonth = DateTime(today.year, today.month, 0);
    var firstDayOfNextMonth = DateTime(today.year, today.month + 1, 1);
    List<Activity> monthActivity = userActivities.where((act) {
      DateTime actDate = dateFormat.parse(act.dateCreated.substring(0, 10));
      return actDate.isBefore(firstDayOfNextMonth) &&
          actDate.isAfter(lastDayOfLastMonth);
    }).toList();
    distancesStatistic[1] = 0;
    timeWorkingStatistic[1] = 0;
    workingCountStatistic[1] = 0;
    monthActivity.forEach((act) {
      distancesStatistic[1] += act.distance;
      timeWorkingStatistic[1] += act.duration;
    });
    workingCountStatistic[1] = monthActivity.length;
    distancesStatistic[1] /= 1000;
  }

  void getYearStatistic() {
    DateTime today = DateTime.now();
    var lastDayOfLastYear = DateTime(today.year, 1, 0);
    var firstDayOfNextYear = DateTime(today.year + 1, 1, 1);
    List<Activity> yearActivity = userActivities.where((act) {
      DateTime actDate = dateFormat.parse(act.dateCreated.substring(0, 10));
      return actDate.isBefore(firstDayOfNextYear) &&
          actDate.isAfter(lastDayOfLastYear);
    }).toList();
    distancesStatistic[2] = 0;
    timeWorkingStatistic[2] = 0;
    workingCountStatistic[2] = 0;
    yearActivity.forEach((act) {
      distancesStatistic[2] += act.distance;
      timeWorkingStatistic[2] += act.duration;
    });
    workingCountStatistic[2] = yearActivity.length;
    distancesStatistic[2] /= 1000;
    getMedal();
  }

  Future<void> getStatistic() async {
    resetData();
    statisticStream = RunningRepo.getUserActivitiesStream();
    await for (var snapshot in statisticStream) {
      print('new activity found!');
      List<Activity> temp =
          snapshot.docs.map((e) => Activity.fromJson(e.data())).toList();
      userActivities.clear();
      userActivities.addAll(temp);
      getWeekStatistic();
      getMonthStatistic();
      getYearStatistic();
    }
  }
}
