import 'package:daily_running/model/home/search/search_view_model.dart';
import 'package:daily_running/model/user/user_view_model.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../home_screen.dart';

class FloatingTabBar extends StatelessWidget {
  final double shrinkOffset;
  final double expandedHeight;

  const FloatingTabBar(
      {@required this.shrinkOffset, @required this.expandedHeight});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          CustomCollapseAppbarDelegate.disappear(shrinkOffset, expandedHeight),
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
  }
}

class SearchButton extends StatelessWidget {
  final double shrinkOffset;
  final double expandedHeight;

  const SearchButton(
      {@required this.shrinkOffset, @required this.expandedHeight});
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          CustomCollapseAppbarDelegate.disappear(shrinkOffset, expandedHeight),
      child: InkResponse(
        onTap: () {
          Provider.of<SearchViewModel>(context, listen: false)
              .showSearchBarAnimated();
        },
        child: SvgPicture.asset(
          'assets/images/ic_search.svg',
          color: Colors.black,
          height: 38,
        ),
      ),
    );
  }
}

class ToolBarTitle extends StatelessWidget {
  final double shrinkOffset;
  final double expandedHeight;

  const ToolBarTitle(
      {@required this.shrinkOffset, @required this.expandedHeight});

  String getGreet() {
    int now = DateTime.now().hour;
    if (now >= 0 && now < 12)
      return "Good morning, ";
    else if (now >= 12 && now <= 18)
      return "Good afternoon, ";
    else
      return "Good evening, ";
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          CustomCollapseAppbarDelegate.disappear(shrinkOffset, expandedHeight),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '${getGreet()}\n${Provider.of<UserViewModel>(context).currentUser.displayName}',
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
  }
}

class ToolBarBackground extends StatelessWidget {
  final double shrinkOffset;
  final double expandedHeight;

  const ToolBarBackground(
      {@required this.shrinkOffset, @required this.expandedHeight});
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          CustomCollapseAppbarDelegate.disappear(shrinkOffset, expandedHeight),
      child: Image.asset(
        'assets/images/home_banner.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
