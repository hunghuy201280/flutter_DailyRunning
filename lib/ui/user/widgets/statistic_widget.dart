import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/user/statistic_view_model.dart';
import 'package:daily_running/ui/user/widgets/statistic_card.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class StatisticWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: kInActiveTabbarColor,
            child: TabBar(
              labelColor: Colors.black,
              indicator: RectangularIndicator(
                color: kActiveTabbarColor,
                paintingStyle: PaintingStyle.fill,
                topLeftRadius: 18,
                topRightRadius: 18,
                bottomLeftRadius: 18,
                bottomRightRadius: 18,
              ),
              tabs: kStatisticTab,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 110,
            child: Consumer<StatisticViewModel>(
              builder: (context, statisticViewModel, _) => TabBarView(
                children: [
                  StatisticCard(
                    distance:
                        '${statisticViewModel.distancesStatistic[0].toStringAsFixed(2)} Km',
                    timeWorking:
                        '${RecordViewModel.getTimeWorking(statisticViewModel.timeWorkingStatistic[0])}',
                    workingCount:
                        '${statisticViewModel.workingCountStatistic[0]}',
                  ),
                  StatisticCard(
                    distance:
                        '${statisticViewModel.distancesStatistic[1].toStringAsFixed(2)} Km',
                    timeWorking:
                        '${RecordViewModel.getTimeWorking(statisticViewModel.timeWorkingStatistic[1])}',
                    workingCount:
                        '${statisticViewModel.workingCountStatistic[1]}',
                  ),
                  StatisticCard(
                    distance:
                        '${statisticViewModel.distancesStatistic[2].toStringAsFixed(2)} Km',
                    timeWorking:
                        '${RecordViewModel.getTimeWorking(statisticViewModel.timeWorkingStatistic[2])}',
                    workingCount:
                        '${statisticViewModel.workingCountStatistic[2]}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
