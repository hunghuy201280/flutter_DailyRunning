import 'package:daily_running/main.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomeScreen extends StatelessWidget {
  static String id = 'HomeScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                  floating: true,
                  delegate: CustomCollapseAppbarDelegate(expandedHeight: 150)),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 24, horizontal: 25),
                  padding:
                      EdgeInsets.only(top: 8, bottom: 16, right: 24, left: 24),
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
                            backgroundImage: AssetImage(
                                'assets/images/place_holder_avatar.png'),
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
                                'Trung Hiếu',
                                style: kPostTextStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '2020-20-20 20:20',
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
                        'Mô tả',
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
                            value: '20Km',
                            description: 'Quãng đường',
                          ),
                          PostColumnText(
                            value: '20 phút',
                            description: 'Thời gian',
                          ),
                          PostColumnText(
                            value: '20 m/ph',
                            description: 'Tốc độ',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image(
                        image: AssetImage(
                          'assets/images/place_holder_post.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          PostBottomIcon(
                            iconName: 'assets/images/ic_heart.svg',
                            value: 20.toString(),
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          PostBottomIcon(
                            iconName: 'assets/images/ic_comment.svg',
                            value: 20.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }, childCount: 10)),
            ],
          ),
        ),
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

class CustomCollapseAppbarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  CustomCollapseAppbarDelegate({
    @required this.expandedHeight,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = 60;
    final top = expandedHeight - shrinkOffset - size / 2;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        buildBackground(shrinkOffset),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Center(
            child: buildTitle(shrinkOffset),
          ),
        ),
        Positioned(
          top: top,
          left: 66,
          right: 66,
          child: buildFloating(shrinkOffset),
        ),
        Positioned(
          child: buildSearchButton(shrinkOffset),
          top: 26,
          right: 26,
        ),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildSearchButton(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: SvgPicture.asset(
          'assets/images/ic_search.svg',
          color: Colors.black,
          height: 38,
        ),
      );
  Widget buildTitle(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Good morning,\nTest User',
                style: TextStyle(
                  fontSize: 30 - shrinkOffset * 0.1,
                  fontFamily: 'SVG Avo',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      );

  Widget buildBackground(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Image.asset(
          'assets/images/home_banner.png',
          fit: BoxFit.cover,
        ),
      );

  Widget buildFloating(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          color: kInActiveTabbarColor,
          child: TabBar(
            tabs: [
              SizedBox(
                height: 35,
                child: Tab(
                  text: 'Đang theo dõi',
                ),
              ),
              SizedBox(
                height: 35,
                child: Tab(
                  text: 'Bạn',
                ),
              ),
            ],
            labelColor: Colors.black,
            indicator: RectangularIndicator(
              color: kActiveTabbarColor,
              paintingStyle: PaintingStyle.fill,
              topLeftRadius: 18,
              topRightRadius: 18,
              bottomLeftRadius: 18,
              bottomRightRadius: 18,
            ),
          ),
        ),
      );

  Widget buildButton({
    @required String text,
    @required IconData icon,
  }) =>
      TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 20)),
          ],
        ),
        onPressed: () {},
      );

  @override
  // TODO: implement maxExtent
  double get maxExtent => expandedHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
