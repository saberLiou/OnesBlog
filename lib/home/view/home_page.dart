// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/home/widgets/locations_carousel_slider.dart';
import 'package:ones_blog/home/widgets/welcome_background_image.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/location_category.dart';
import 'package:ones_blog/utils/size_handler.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<HomePage> route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );

  @override
  Widget build(BuildContext context) => const HomeView();
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: const MenuView(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            const FixedAppBar(
              pinned: false,
              primaryBackgroundColor: false,
              homeLeadingIcon: null,
            ),
          ],
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: SizeHandler.screenHeight - 160,
                      color: AppColors.secondary,
                    ),
                    WelcomeBackgroundImage(
                      top: SizeHandler.screenHeight / 40,
                      left: SizeHandler.screenWidth / 10,
                      imageUrl: 'images/background/croissant.png',
                      imageWidth: 120,
                    ),
                    WelcomeBackgroundImage(
                      top: SizeHandler.screenHeight / 4.5,
                      left: SizeHandler.screenWidth / 15,
                      imageUrl: 'images/text/titleWord.png',
                      imageWidth: 300,
                    ),
                    WelcomeBackgroundImage(
                      top: SizeHandler.screenHeight / 20,
                      left: SizeHandler.screenWidth / 1.3,
                      imageUrl: 'images/background/strawberry.png',
                      imageWidth: 120,
                    ),
                    WelcomeBackgroundImage(
                      top: SizeHandler.screenHeight / 2.5,
                      left: SizeHandler.screenWidth / -8,
                      imageUrl: 'images/background/donut.png',
                      imageWidth: 120,
                    ),
                    WelcomeBackgroundImage(
                      top: SizeHandler.screenHeight / 1.8,
                      left: SizeHandler.screenWidth / 1.6,
                      imageUrl: 'images/background/matcha.png',
                      imageWidth: 120,
                    ),
                    WelcomeBackgroundImage(
                      top: SizeHandler.screenHeight / 1.42,
                      left: SizeHandler.screenWidth / 8,
                      imageUrl: 'images/background/blueberry.png',
                      imageWidth: 130,
                    ),
                  ],
                ),
                Container(
                  height: 1700,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('images/background/background_body.png'),
                      alignment: Alignment.topCenter,
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                          height: SpaceUnit.threeQuarterBase,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppButton(
                            height: SpaceUnit.base * 6,
                            width: SpaceUnit.base * 13,
                            title: l10n.restaurant,
                            onPressed: () {},
                          ),
                          AppButton(
                            height: SpaceUnit.base * 6,
                            width: SpaceUnit.base * 13,
                            title: l10n.spot,
                            onPressed: () {},
                          ),
                          AppButton(
                            height: SpaceUnit.base * 6,
                            width: SpaceUnit.base * 13,
                            title: l10n.lodging,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      for (final category in LocationCategory.values) ...[
                        Padding(
                          padding:
                              const EdgeInsets.all(SpaceUnit.quadrupleBase),
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage(
                                  'images/text/${category.name}.png',
                                ),
                                width: 100,
                              ),
                            ],
                          ),
                        ),
                        LocationsCarouselSlider(categoryId: category.id),
                        const SizedBox(
                          height: SpaceUnit.threeQuarterBase,
                        ),
                        AppButton(
                          height: SpaceUnit.base * 6,
                          width: MediaQuery.of(context).size.width / 2,
                          title: l10n.more(l10n.restaurant.toLowerCase()),
                          onPressed: () {},
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class CounterText extends StatelessWidget {
//   const CounterText({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final count = context.select((LocationsCubit cubit) => cubit.state);
//     return Text('$count', style: theme.textTheme.headline1);
//   }
// }
