import 'package:daily_running/main.dart';
import 'package:daily_running/model/home/navBar/nav_bar_view_model.dart';
import 'package:daily_running/ui/home/widgets/post_view.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomeScreen extends StatelessWidget {
  static String id = 'HomeScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, isScroll) {
              return [
                SliverPersistentHeader(
                    delegate:
                        CustomCollapseAppbarDelegate(expandedHeight: 150)),
              ];
            },
            body: TabBarView(
              children: [
                PostListView(),
                PostListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostListView extends StatefulWidget {
  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView>
    with AutomaticKeepAliveClientMixin<PostListView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemBuilder: (context, index) {
        return PostView(
          avatar: AssetImage('assets/images/place_holder_avatar.png'),
          ownerName: 'Trung Hiếu',
          dateTime: '2020-20-20 20:20',
          description:
              'This is description This is description This is description',
          distance: 20.12313,
          timeWorking: 20.2,
          pace: 20.3,
          mapImage: AssetImage(
            'assets/images/place_holder_post.png',
          ),
          like: 20,
          comment: 20,
        );
      },
      itemCount: 10,
    );
  }

  @override
  bool get wantKeepAlive => true;
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
          child: buildFloatingTabBar(shrinkOffset),
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

  Widget buildFloatingTabBar(double shrinkOffset) => Opacity(
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
