import 'package:flutter/material.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/location/widgets/locations_carousel_slider.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/location_category.dart';
import 'package:ones_blog/utils/size_handler.dart';

class LocationRankingPage extends StatelessWidget {
  const LocationRankingPage({super.key});

  static Route<LocationRankingPage> route() => MaterialPageRoute(
        builder: (context) => const LocationRankingPage(),
      );

  @override
  Widget build(BuildContext context) => const LocationRankingView();
}

class LocationRankingView extends StatelessWidget {
  const LocationRankingView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: const MenuView(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            FixedAppBar(
              toolbarHeight: SpaceUnit.base * 16,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: SpaceUnit.threeQuarterBase,
                          ),
                          child: Image.asset(
                            'images/text/rankWord.png',
                            height: 55,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: SingleChildScrollView(
            child: Column(
              children: [
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
                        LocationsCarouselSlider(
                          category: category,
                          ranking: 10,
                        ),
                        const SizedBox(
                          height: SpaceUnit.threeQuarterBase,
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
