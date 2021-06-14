import 'dart:math';
import 'dart:ui';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:daily_running/model/home/search/search_view_model.dart';
import 'package:daily_running/ui/home/search/animated_floating_search_bar.dart';
import 'package:daily_running/ui/home/widgets/post_list_view.dart';
import 'package:daily_running/ui/home/widgets/post_view.dart';
import 'package:daily_running/ui/home/widgets/tool_bar_widget.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String id = 'HomeScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            DefaultTabController(
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
            AnimatedFloatingSearchBar(),
          ],
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
