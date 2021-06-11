import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostView extends StatelessWidget {
  final ImageProvider avatar;
  final String ownerName;
  final String dateTime;
  final String description;
  final double distance;
  final double timeWorking;
  final double pace;
  final ImageProvider mapImage;
  final int like;
  final int comment;

  const PostView({
    @required this.avatar,
    @required this.ownerName,
    @required this.dateTime,
    @required this.description,
    @required this.distance,
    @required this.timeWorking,
    @required this.pace,
    @required this.mapImage,
    @required this.like,
    @required this.comment,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24, horizontal: 25),
      padding: EdgeInsets.only(top: 8, bottom: 16, right: 24, left: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kConcreteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: avatar,
                radius: 22,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ownerName,
                    style: kPostTextStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    dateTime,
                    style: kPostTextStyle,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 14,
          ),
          Text(
            description,
            style: kPostTextStyle.copyWith(fontSize: 16),
          ),
          Divider(
            color: kDividerColor,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PostColumnText(
                value: '${distance.toStringAsFixed(2)}Km',
                description: 'Quãng đường',
              ),
              PostColumnText(
                value: '${timeWorking.toStringAsFixed(2)} phút',
                description: 'Thời gian',
              ),
              PostColumnText(
                value: '${pace.toStringAsFixed(2)} m/ph',
                description: 'Tốc độ',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Image(
            image: mapImage,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              PostBottomIcon(
                iconName: 'assets/images/ic_heart.svg',
                value: like.toString(),
              ),
              SizedBox(
                width: 22,
              ),
              PostBottomIcon(
                iconName: 'assets/images/ic_comment.svg',
                value: comment.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PostBottomIcon extends StatelessWidget {
  final String iconName;
  final String value;

  const PostBottomIcon({
    @required this.iconName,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: SvgPicture.asset(
            iconName,
            height: 13,
          ),
          onTap: () {},
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          value,
          style: kPostTextStyle.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: kDividerColor,
          ),
        )
      ],
    );
  }
}

class PostColumnText extends StatelessWidget {
  final String value;
  final String description;

  const PostColumnText({@required this.value, @required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: kPostTextStyle.copyWith(
              fontSize: 12, fontWeight: FontWeight.w700),
        ),
        Text(
          description,
          style: kPostTextStyle,
        ),
      ],
    );
  }
}
