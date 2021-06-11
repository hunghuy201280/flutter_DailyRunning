import 'package:cool_alert/cool_alert.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/ui/home/main_screen.dart';
import 'package:daily_running/ui/record/widgets/finish_record_info_column.dart';
import 'package:daily_running/ui/record/widgets/smoll_button.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class FinishRecordScreen extends StatelessWidget {
  static String id = 'FinishRecordScreen';
  final describeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lưu hoạt động'),
        backgroundColor: kPrimaryColor,
      ),
      body: WillPopScope(
        onWillPop: () async =>
            Provider.of<RecordViewModel>(context, listen: false).resetData(),
        child: ModalProgressHUD(
          inAsyncCall: Provider.of<RecordViewModel>(context).isLoading,
          progressIndicator: SpinKitChasingDots(
            color: kPrimaryColor,
            size: 50,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin hoạt động',
                    style: kBigTitleTextStyle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 1, color: Colors.grey),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FinishRecordInfoColumn(
                              title: 'Quãng đường',
                              value: Provider.of<RecordViewModel>(context)
                                  .distanceString,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FinishRecordInfoColumn(
                                    title: 'Thời gian di chuyển',
                                    value: Provider.of<RecordViewModel>(context)
                                        .timeWorking,
                                  ),
                                  VerticalDivider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                  FinishRecordInfoColumn(
                                    title: 'Tốc độ trung bình',
                                    value: Provider.of<RecordViewModel>(context)
                                        .averageSpeed,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Mô tả',
                    style: kBigTitleTextStyle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextField(
                      controller: describeController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        hintText:
                            'Buổi tập của bạn như thế nào? Hãy chia sẻ với bạn bè!',
                      ),
                    ),
                  ),
                  Text(
                    'Tích lũy',
                    style: kBigTitleTextStyle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/images/ic_running_point.png',
                        height: 60,
                      ),
                      Text(
                        '${Provider.of<RecordViewModel>(context).runningPoint} điểm Running',
                        style: kBigTitleTextStyle.copyWith(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SmollButton(
                        text: 'Hủy',
                        onPress: () {},
                        backgroundColor: kInActiveTabbarColor,
                        textColor: kMineShaftColor,
                      ),
                      SmollButton(
                        text: 'Lưu',
                        onPress: () => onSaveClick(context),
                        backgroundColor: kPrimaryColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSaveClick(BuildContext context) async {
    if (Provider.of<RecordViewModel>(context, listen: false).isSave) return;
    Provider.of<RecordViewModel>(context, listen: false).setSaveButton(true);
    String result = await Provider.of<RecordViewModel>(context, listen: false)
        .onSaveClick(describeController.text);
    if (result == null) {
      await CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        autoCloseDuration: Duration(seconds: 3, milliseconds: 500),
      );
      Provider.of<UserViewModel>(context, listen: false).addRunningPoint(
          Provider.of<RecordViewModel>(context, listen: false).runningPoint);
      Provider.of<RecordViewModel>(context, listen: false).resetData();
      Navigator.pushReplacementNamed(context, MainScreen.id);
    } else {
      CoolAlert.show(
        context: context,
        text: result,
        type: CoolAlertType.error,
        autoCloseDuration: Duration(seconds: 3),
      );
    }
  }
}
