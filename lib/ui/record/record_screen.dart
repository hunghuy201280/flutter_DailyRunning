import 'package:daily_running/model/home/navBar/nav_bar_view_model.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/ui/record/finish_record_screen.dart';
import 'package:daily_running/ui/record/widgets/record_button_row.dart';
import 'package:daily_running/ui/record/widgets/time_distance_row.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RecordScreen extends StatelessWidget {
  static String id = 'RecordScreen';
  @override
  Widget build(BuildContext context) {
    print('rebuild 1');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<RecordViewModel>(
                  builder: (context, recordViewModel, child) {
                    print('rebuild 2');

                    return AnimatedContainer(
                      height: recordViewModel.isExpand ? 190 : 30,
                      width: double.infinity,
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Visibility(
                                  visible: recordViewModel.isExpand,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    child: Column(
                                      children: [
                                        TimeDistanceRow(
                                          time: '00:12:39',
                                          distance: '20.21Km',
                                        ),
                                        RecordButtonRow(
                                          onContinuePress: () {
                                            Provider.of<RecordViewModel>(
                                                    context,
                                                    listen: false)
                                                .toggleStop();
                                          },
                                          onStopPress: () {
                                            Navigator.pushNamed(
                                                context, FinishRecordScreen.id);
                                          },
                                          onPausePress: () {
                                            Provider.of<RecordViewModel>(
                                                    context,
                                                    listen: false)
                                                .toggleStop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Provider.of<RecordViewModel>(context,
                                        listen: false)
                                    .toggleExpand();
                              },
                              child: Ink(
                                child: Icon(
                                  recordViewModel.isExpand
                                      ? Icons.arrow_drop_up_outlined
                                      : Icons.arrow_drop_down_outlined,
                                  size: 30,
                                ),
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      ),
                      duration: Duration(milliseconds: 200),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 20),
                  child: kAppNameTextBlack,
                ),
              ],
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkResponse(
                  radius: 20,
                  onTap: () {},
                  child: Icon(
                    FontAwesomeIcons.spotify,
                    color: kSpotifyColor,
                    size: 35,
                  ),
                ),
              ),
              alignment: Alignment.bottomLeft,
            ),
          ],
        ),
      ),
    );
  }
}
