import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit({
    required this.locationRepository,
  }) : super(const LocationsState());

  final LocationRepository locationRepository;

  Future<void> fetchLocations({required int categoryId, int limit = 10}) async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      final locations = await locationRepository.listLocations(
        categoryId: categoryId,
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

  void setPage(int page) => emit(state.copyWith(currentPage: page));
}
