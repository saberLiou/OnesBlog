import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/location/cubit/locations_cubit.dart';
import 'package:ones_blog/location/show/location_show.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';

class LocationsCarouselSlider extends StatelessWidget {
  const LocationsCarouselSlider({
    super.key,
    required this.category,
    this.ranking,
    this.random,
  });

  final LocationCategory category;
  final int? random;
  final int? ranking;

  @override
  Widget build(BuildContext context) => BlocProvider<LocationsCubit>.value(
        value: LocationsCubit(
          locationRepository: context.read<LocationRepository>(),
          category: category,
          random: random,
          ranking: ranking,
        )..fetchLocations(),
        child: _Content(),
      );
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((LocationsCubit cubit) => cubit.state.status);

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
      case BlocCubitStatus.failure:
        return Center(
          key: const Key('content_failure_text'),
          child: Text(l10n.listFetchErrorMessage),
        );
      case BlocCubitStatus.success:
        return const LocationsCarouselSliderView(
          key: Key('content_success_carouselSlider'),
        );
    }
  }
}

class LocationsCarouselSliderView extends StatefulWidget {
  const LocationsCarouselSliderView({super.key});

  @override
  State createState() => _LocationsCarouselSliderViewState();
}

class _LocationsCarouselSliderViewState
    extends State<LocationsCarouselSliderView> {
  /// A method that launches the [LocationShowPage],
  /// and awaits for Navigator.pop.
  Future<void> _navigateLocationShowPage(
      BuildContext context, Location location) async {
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
      await context.read<LocationsCubit>().fetchLocations();
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LocationsCubit, LocationsState>(
        builder: (context, state) => Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
                aspectRatio: SpaceUnit.quarterBase,
                enlargeCenterPage: true,
                onPageChanged: (index, _) =>
                    context.read<LocationsCubit>().setPage(index),
              ),
              items: [
                for (final location in state.locations!) ...[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: InkWell(
                      child: Card(
                        color: AppColors.muted,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              SpaceUnit.doubleBase,
                            ),
                          ),
                        ),
                        elevation: SpaceUnit.halfBase,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // TODO: real images
                            Container(
                              height: SpaceUnit.base * 20,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(SpaceUnit.doubleBase),
                                  topRight:
                                      Radius.circular(SpaceUnit.doubleBase),
                                ),
                              ),
                              child: state.category.defaultImage(),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: SpaceUnit.base,
                                ),
                                child: Center(
                                  child: Text(
                                    location.name,
                                    style: AppTextStyle.title,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                right: SpaceUnit.base,
                                bottom: SpaceUnit.base,
                                left: SpaceUnit.base,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    location.cityAndArea ?? '',
                                    style: AppTextStyle.content,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      Text(
                                        location.avgScore.toStringAsFixed(2),
                                        style: AppTextStyle.content,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => _navigateLocationShowPage(context, location),
                    ),
                  ),
                ]
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: SpaceUnit.base),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (MapEntry<dynamic, dynamic> locationEntry
                      in state.locations!.asMap().entries) ...[
                    Container(
                      width: SpaceUnit.base,
                      height: SpaceUnit.base,
                      margin: const EdgeInsets.symmetric(
                        vertical: SpaceUnit.base,
                        horizontal: SpaceUnit.quarterBase,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(
                          0,
                          0,
                          0,
                          (state.currentPage == locationEntry.key) ? 0.9 : 0.4,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      );
}
