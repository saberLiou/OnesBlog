import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/city_repository.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/location/list/location_list.dart';
import 'package:ones_blog/location/show/location_show.dart';
import 'package:ones_blog/location/widgets/location_card.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';
import 'package:ones_blog/utils/size_handler.dart';

class LocationListPage extends StatelessWidget {
  const LocationListPage({super.key});

  static Route<LocationListPage> route(LocationCategory locationCategory) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider<LocationListCubit>.value(
          value: LocationListCubit(
            cityRepository: context.read<CityRepository>(),
            locationRepository: context.read<LocationRepository>(),
            locationCategory: locationCategory,
          )..init(),
          child: const LocationListPage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const LocationListView();
}

class LocationListView extends StatelessWidget {
  const LocationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locationListCubit = context.read<LocationListCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: const MenuView(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            FixedAppBar(
              toolbarHeight: SpaceUnit.base * 20,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: BlocBuilder<LocationListCubit, LocationListState>(
                  builder: (context, state) => Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: SpaceUnit.threeQuarterBase,
                            ),
                            child: Image.asset(
                              'images/text/${state.locationCategory.name}Word.png',
                              height: 55,
                            ),
                          ),
                          Container(
                            width: 200,
                            height: SpaceUnit.base * 6,
                            margin: const EdgeInsets.symmetric(
                              vertical: SpaceUnit.doubleBase,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(SpaceUnit.base),
                              ),
                            ),
                            child: DropdownButtonFormField2(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              value: state.cityId,
                              onChanged: (value) => locationListCubit
                                  .selectCity(cityId: value! as int),
                              items: state.cities
                                  ?.map(
                                    (city) => DropdownMenuItem<int>(
                                      value: city.id,
                                      child: Center(
                                        child: Text(
                                          city.city,
                                          style: AppTextStyle.content,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 1700,
                  width: SizeHandler.screenWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('images/background/background_body.png'),
                      alignment: Alignment.topCenter,
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                  child: _Content(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status =
        context.select((LocationListCubit cubit) => cubit.state.status);

    switch (status) {
      case BlocCubitStatus.initial:
        return const SizedBox(
          key: Key('content_initial_sizedBox'),
        );
      case BlocCubitStatus.loading:
        return const Center(
          key: Key('content_loading_indicator'),
          child: CircularProgressIndicator.adaptive(),
        );
      case BlocCubitStatus.success:
        return const _LocationListTiles(
          key: Key('content_success_carouselSlider'),
        );
      case BlocCubitStatus.failure:
        return Center(
          key: const Key('content_failure_text'),
          child: Text(l10n.listFetchErrorMessage),
        );
    }
  }
}

class _LocationListTiles extends StatefulWidget {
  const _LocationListTiles({super.key});

  @override
  State createState() => _LocationListTilesState();
}

class _LocationListTilesState extends State<_LocationListTiles> {
  /// A method that launches the [LocationShowPage],
  /// and awaits for Navigator.pop.
  Future<void> _navigateLocationShowPage(
    BuildContext context,
    Location location,
  ) async {
    /// Navigator.push returns a Future that completes after calling
    /// Navigator.pop on the LocationShowPage Screen.
    final result = await Navigator.push(
      context,
      LocationShowPage.route(location: location),
    );

    /// When a BuildContext is used from a StatefulWidget, the mounted property
    /// must be checked after an asynchronous gap.
    if (!mounted) return;

    if (result?.page == PoppedFromPage.showLocation) {
      final locationListCubit = context.read<LocationListCubit>();
      await locationListCubit.selectCity(
        cityId: locationListCubit.state.cityId,
      );
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LocationListCubit, LocationListState>(
        builder: (context, state) => Column(
          children: [
            for (final location in state.locations!) ...[
              InkWell(
                onTap: () => _navigateLocationShowPage(context, location),
                child: LocationCard(location: location),
              ),
            ],
          ],
        ),
      );
}
