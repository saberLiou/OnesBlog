import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/home/cubit/locations_cubit.dart';
import 'package:ones_blog/l10n/l10n.dart';
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
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => LocationsCubit(
          locationRepository: context.read<LocationRepository>(),
        )..fetchLocations(categoryId: categoryId, limit: 6),
        child: const _Content(),
      );
}

class _Content extends StatelessWidget {
  const _Content({super.key});

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
          child: Text(l10n.locationsFetchErrorMessage),
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
                height: 260,
                aspectRatio: 2,
                enlargeCenterPage: true,
                onPageChanged: (index, _) =>
                    context.read<LocationsCubit>().setPage(index),
              ),
              items: [
                for (final location in state.locations!) ...[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(198, 201, 203, 1),
                    ),
                    child: Center(
                      child: Text(
                        location.name,
                        style: AppTextStyle.title,
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
