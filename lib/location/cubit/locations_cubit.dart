import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';

part 'locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit({
    required this.locationRepository,
    required LocationCategory category,
    required int? random,
    required int? ranking,
  }) : super(
          LocationsState(
            category: category,
            random: random,
            ranking: ranking,
          ),
        );

  final LocationRepository locationRepository;

  Future<void> fetchLocations({int limit = 10}) async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      final locations = await locationRepository.listLocations(
        categoryId: state.category.id,
        random: state.random,
        ranking: state.ranking,
        limit: state.random ?? state.ranking ?? limit,
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

  void setPage(int page) => emit(state.copyWith(currentPage: page));
}
