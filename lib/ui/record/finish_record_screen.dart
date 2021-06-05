import 'package:daily_running/ui/record/widgets/finish_record_info_column.dart';
import 'package:daily_running/ui/record/widgets/smoll_button.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FinishRecordScreen extends StatelessWidget {
  static String id = 'FinishRecordScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lưu hoạt động'),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
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
                          value: '20Km',
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FinishRecordInfoColumn(
                                title: 'Thời gian di chuyển',
                                value: '20 ph',
                              ),
                              VerticalDivider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              FinishRecordInfoColumn(
                                title: 'Tốc độ trung bình',
                                value: '20 m/ph',
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
                    '20 điểm Running',
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
                    onPress: () {},
                    backgroundColor: kPrimaryColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
