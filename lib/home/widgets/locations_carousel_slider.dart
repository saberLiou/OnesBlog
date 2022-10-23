import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/home/cubit/locations_cubit.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

class LocationsCarouselSlider extends StatelessWidget {
  const LocationsCarouselSlider({
    super.key,
    required this.categoryId,
  });

  final int categoryId;

  @override
  Widget build(BuildContext context) => BlocProvider<LocationsCubit>.value(
        value: LocationsCubit(
          locationRepository: context.read<LocationRepository>(),
        )..fetchLocations(categoryId: categoryId, limit: 6),
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
        return const _LocationsCarouselSlider(
          key: Key('content_success_carouselSlider'),
        );
    }
  }
}

class _LocationsCarouselSlider extends StatelessWidget {
  const _LocationsCarouselSlider({super.key});

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
                                topLeft: Radius.circular(SpaceUnit.doubleBase),
                                topRight: Radius.circular(SpaceUnit.doubleBase),
                              ),
                            ),
                            child: Image.network(
                              'https://picsum.photos/seed/picsum/1024/768',
                              fit: BoxFit.fill,
                            ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TODO: address -> city + area.
                                Text(
                                  location.address,
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
                                      location.avgScore.toString(),
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
