import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/city.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/city_repository.dart';
import 'package:ones_blog/domain/location_repository.dart';

import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';

part 'location_list_state.dart';

class LocationListCubit extends Cubit<LocationListState> {
  LocationListCubit({
    required this.cityRepository,
    required this.locationRepository,
    required LocationCategory locationCategory,
  }) : super(LocationListState(locationCategory: locationCategory));

  final CityRepository cityRepository;
  final LocationRepository locationRepository;

  Future<void> init({
    int limit = 10,
  }) async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      final cities = await cityRepository.listCities();
      final locations = await locationRepository.listLocations(
        categoryId: state.locationCategory.id,
        cityId: state.cityId,
        limit: limit,
      );
      emit(
        state.copyWith(
          status: BlocCubitStatus.success,
          cities: cities,
          locations: locations,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }

  Future<void> selectCity({
    required int cityId,
    int limit = 10,
  }) async {
    emit(
      state.copyWith(
        status: BlocCubitStatus.loading,
        cityId: cityId,
        locations: [],
      ),
    );

    try {
      final locations = await locationRepository.listLocations(
        categoryId: state.locationCategory.id,
        cityId: state.cityId,
        limit: limit,
      );
      emit(
        state.copyWith(
          status: BlocCubitStatus.success,
          locations: locations,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
