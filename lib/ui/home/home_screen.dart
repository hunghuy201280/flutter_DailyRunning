import 'package:daily_running/ui/home/widgets/post_list_view.dart';
import 'package:daily_running/ui/home/widgets/post_view.dart';
import 'package:daily_running/ui/home/widgets/tool_bar_widget.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                PostListView(type: PostType.Following), //Follow
                PostListView(type: PostType.Me), //Me
              ],
            ),
          ),
        ),
      ),
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
/*    final String userName =
        Provider.of<UserViewModel>(context).currentUser.displayName;*/
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        ToolBarBackground(
            shrinkOffset: shrinkOffset, expandedHeight: expandedHeight),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Center(
            child: ToolBarTitle(
                shrinkOffset: shrinkOffset, expandedHeight: expandedHeight),
          ),
        ),
        Positioned(
          top: top,
          left: 66,
          right: 66,
          child: FloatingTabBar(
              shrinkOffset: shrinkOffset, expandedHeight: expandedHeight),
        ),
        Positioned(
          child: SearchButton(
              shrinkOffset: shrinkOffset, expandedHeight: expandedHeight),
          top: 26,
          right: 26,
        ),
      ],
    );
  }

  static double appear(double shrinkOffset, double expandedHeight) =>
      shrinkOffset / expandedHeight;

  static double disappear(double shrinkOffset, double expandedHeight) =>
      1 - shrinkOffset / expandedHeight;

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
/*
  Widget buildSearchButton(double shrinkOffset,double expandedHeight) => Opacity(
        opacity: CustomCollapseAppbarDelegate.disappear(shrinkOffset,expandedHeight),
        child: InkResponse(
          onTap: () {},
          child: SvgPicture.asset(
            'assets/images/ic_search.svg',
            color: Colors.black,
            height: 38,
          ),
        ),
      );
  Widget buildTitle(double shrinkOffset, String userName, double expandedHeight) => Opacity(
        opacity: CustomCollapseAppbarDelegate.disappear(shrinkOffset,expandedHeight),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Good morning,\n$userName',
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

  Widget buildBackground(double shrinkOffset,double expandedHeight) => Opacity(
        opacity: CustomCollapseAppbarDelegate.disappear(shrinkOffset,expandedHeight),
        child: Image.asset(
          'assets/images/home_banner.png',
          fit: BoxFit.cover,
        ),
      );

  Widget buildFloatingTabBar(double shrinkOffset, double expandedHeight) => Opacity(
        opacity: CustomCollapseAppbarDelegate.disappear(shrinkOffset,expandedHeight),
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
*/
