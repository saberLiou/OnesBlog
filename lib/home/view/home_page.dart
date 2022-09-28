// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/open_menu_button.dart';
import 'package:ones_blog/home/widgets/locations_carousel_slider.dart';
import 'package:ones_blog/home/widgets/welcome_background_image.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/location_category.dart';

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
    final screenHeight = MediaQuery.of(context).size.height,
        screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      endDrawer: const MenuView(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          const SliverAppBar(
            backgroundColor: AppColors.secondary,
            elevation: 0,
            toolbarHeight: 70,
            actions: [
              OpenMenuButton(),
            ],
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: screenHeight - 160,
                    color: AppColors.secondary,
                  ),
                  WelcomeBackgroundImage(
                    top: screenHeight / 40,
                    left: screenWidth / 10,
                    imageUrl: 'images/background/croissant.png',
                    imageWidth: 120,
                  ),
                  WelcomeBackgroundImage(
                    top: screenHeight / 4.5,
                    left: screenWidth / 15,
                    imageUrl: 'images/text/titleWord.png',
                    imageWidth: 300,
                  ),
                  WelcomeBackgroundImage(
                    top: screenHeight / 20,
                    left: screenWidth / 1.3,
                    imageUrl: 'images/background/strawberry.png',
                    imageWidth: 120,
                  ),
                  WelcomeBackgroundImage(
                    top: screenHeight / 2.5,
                    left: screenWidth / -8,
                    imageUrl: 'images/background/donut.png',
                    imageWidth: 120,
                  ),
                  WelcomeBackgroundImage(
                    top: screenHeight / 1.8,
                    left: screenWidth / 1.6,
                    imageUrl: 'images/background/matcha.png',
                    imageWidth: 120,
                  ),
                  WelcomeBackgroundImage(
                    top: screenHeight / 1.42,
                    left: screenWidth / 8,
                    imageUrl: 'images/background/blueberry.png',
                    imageWidth: 130,
                  ),
                ],
              ),
              Container(
                height: 1600,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/background/background_body.png'),
                    alignment: Alignment.topCenter,
                    repeat: ImageRepeat.repeat,
                  ),
                ),
                child: Column(
                  children: [
                    for (final category in LocationCategory.values) ...[
                      Padding(
                        padding: const EdgeInsets.all(SpaceUnit.quadrupleBase),
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
                    ],
                  ],
                ),
              ),
            ],
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