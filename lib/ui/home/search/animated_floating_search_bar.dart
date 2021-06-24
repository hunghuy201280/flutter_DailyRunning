import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:daily_running/model/home/search/search_view_model.dart';
import 'package:daily_running/model/user/other_user/other_profile_view_model.dart';
import 'package:daily_running/ui/user/other_user/other_user_screen.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedFloatingSearchBar extends StatefulWidget {
  const AnimatedFloatingSearchBar({
    Key key,
  }) : super(key: key);

  @override
  _AnimatedFloatingSearchBarState createState() =>
      _AnimatedFloatingSearchBarState();
}

class _AnimatedFloatingSearchBarState extends State<AnimatedFloatingSearchBar>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<SearchViewModel>(context, listen: false).animationController =
        animationController;
  }

  @override
  Widget build(BuildContext context) {
    return CircularRevealAnimation(
      animation: animation,
      centerAlignment: Alignment.topRight,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: FloatingSearchBar(
          controller: Provider.of<SearchViewModel>(context, listen: false)
              .searchBarController,
          hint: 'Search...',
          scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
          transitionDuration: const Duration(milliseconds: 800),
          transitionCurve: Curves.easeInOut,
          physics: const BouncingScrollPhysics(),
          openAxisAlignment: 0.0,
          width: 600,
          debounceDelay: const Duration(milliseconds: 500),
          onQueryChanged: (query) {
            Provider.of<SearchViewModel>(context, listen: false).search(query);
          },
          // Specify a custom transition to be used for
          // animating between opened and closed stated.
          transition: CircularFloatingSearchBarTransition(),
          actions: [
            FloatingSearchBarAction(
              showIfOpened: true,
              showIfClosed: false,
              child: CircularButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  Provider.of<SearchViewModel>(context, listen: false)
                      .searchBarController
                      .clear();
                },
              ),
            ),
          ],
          body: GestureDetector(
            onTap: () {
              Provider.of<SearchViewModel>(context, listen: false)
                  .hideSearchBar();
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: Provider.of<SearchViewModel>(context)
                              .searchResult
                              .length ==
                          0
                      ? [
                          Container(
                            height: 56,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              Provider.of<SearchViewModel>(context)
                                      .searchQuery
                                      .isEmpty
                                  ? 'Bắt đầu tìm kiếm...'
                                  : 'Không có kết quả ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kSmallTitleTextStyle.copyWith(
                                  color: kPrimaryColor, fontSize: 16),
                            ),
                          )
                        ]
                      : Provider.of<SearchViewModel>(context)
                          .searchResult
                          .map(
                            (user) => ListTile(
                              title: Text(
                                user.displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                Provider.of<OtherProfileViewModel>(context,
                                        listen: false)
                                    .onUserSelected(user.userID);

                                pushNewScreen(
                                  context,
                                  screen: OtherUserScreen(),
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                  withNavBar: false,
                                );
                              },
                              leading: CachedNetworkImage(
                                imageUrl: user.avatarUri,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 20,
                                  backgroundImage: imageProvider,
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: kSecondaryColor,
                                  highlightColor: Colors.grey[100],
                                  child: CircleAvatar(
                                    radius: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
