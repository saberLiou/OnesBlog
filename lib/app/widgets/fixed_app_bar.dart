import 'package:flutter/material.dart';
import 'package:ones_blog/home/view/home_page.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';

class FixedAppBar extends StatelessWidget {
  const FixedAppBar({
    super.key,
    this.pinned = true,
    this.primaryBackgroundColor = true,
    this.toolbarHeight = SpaceUnit.base * 9,
    this.homeLeadingIcon = true,
    this.arguments,
    this.openMenuIcon = true,
    this.bottom,
  });

  final bool pinned;
  final bool primaryBackgroundColor;
  final double toolbarHeight;

  /// false: arrow back icon for popping page; null: without home-leading icon.
  final bool? homeLeadingIcon;

  /// The result during popping if [homeLeadingIcon] is false.
  final PoppedFromPageArguments? arguments;

  /// false: close icon for popping page; null: without open-menu icon.
  final bool? openMenuIcon;

  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) => SliverAppBar(
        pinned: pinned,
        backgroundColor:
            primaryBackgroundColor ? AppColors.primary : AppColors.secondary,
        elevation: 0,
        automaticallyImplyLeading: false,
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
                        onPressed: () => Navigator.pop(context, arguments),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.black,
                          size: SpaceUnit.base * 5,
                        ),
                      ),
              )
            : null,
        toolbarHeight: toolbarHeight,
        leadingWidth: (homeLeadingIcon != null) ? SpaceUnit.base * 12 : null,
        actions: [
          if (openMenuIcon != null)
            IconButton(
              padding: EdgeInsets.only(
                right: openMenuIcon! ? SpaceUnit.base : SpaceUnit.doubleBase,
              ),
              icon: openMenuIcon!
                  ? Image.asset('images/element/menu.png')
                  : const Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
              iconSize:
                  openMenuIcon! ? SpaceUnit.base * 9 : SpaceUnit.quadrupleBase,
              onPressed: () => openMenuIcon!
                  ? Scaffold.of(context).openEndDrawer()
                  : Navigator.pop(context, arguments),
            ),
        ],
        bottom: bottom,
      );
}
