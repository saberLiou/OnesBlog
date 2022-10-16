import 'package:flutter/material.dart';
import 'package:ones_blog/home/view/home_page.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';

class FixedAppBar extends StatelessWidget {
  const FixedAppBar({
    super.key,
    this.pinned = true,
    this.primaryBackgroundColor = true,
    this.homeLeadingIcon = true,
    this.backResult,
    this.openMenuIcon = true,
  });

  final bool pinned;
  final bool primaryBackgroundColor;

  /// false: arrow back icon for popping page; null: without home-leading icon.
  final bool? homeLeadingIcon;

  /// The result during popping if [homeLeadingIcon] is false.
  final String? backResult;

  /// false: without open-menu icon.
  final bool openMenuIcon;

  @override
  Widget build(BuildContext context) => SliverAppBar(
        pinned: pinned,
        backgroundColor:
            primaryBackgroundColor ? AppColors.primary : AppColors.secondary,
        elevation: 0,
        leading: (homeLeadingIcon != null)
            ? Builder(
                builder: (context) => homeLeadingIcon!
                    ? IconButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          HomePage.route(),
                        ),
                        icon: Image.asset('images/icon/icon.png'),
                      )
                    : IconButton(
                        onPressed: () => Navigator.pop(context, backResult),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.black,
                          size: SpaceUnit.base * 5,
                        ),
                      ),
              )
            : (homeLeadingIcon as Widget?),
        toolbarHeight: SpaceUnit.base * 9,
        leadingWidth: (homeLeadingIcon != null) ? SpaceUnit.base * 12 : null,
        actions: [
          if (openMenuIcon)
            IconButton(
              icon: Image.asset('images/element/menu.png'),
              iconSize: SpaceUnit.base * 9,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
        ],
      );
}
