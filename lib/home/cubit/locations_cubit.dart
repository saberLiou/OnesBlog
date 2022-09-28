import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit({
    required LocationRepository locationRepository,
  })  : _locationRepository = locationRepository,
        super(const LocationsState());

  final LocationRepository _locationRepository;

  Future<void> fetchLocations({required int categoryId, int limit = 10}) async {
    emit(
      LocationsState(
        status: BlocCubitStatus.loading,
        locations: state.locations,
      ),
    );

    try {
      final locations = await _locationRepository.listLocations(
        categoryId: categoryId,
        limit: limit,
      );
      emit(
        LocationsState(
          status: BlocCubitStatus.success,
          locations: locations,
        ),
      );
    } on Exception {
      emit(
        LocationsState(
          status: BlocCubitStatus.failure,
          locations: state.locations,
        ),
      );
    }
  }

  void setPage(int page) => emit(LocationsState(
        status: state.status,
        locations: state.locations,
        currentPage: page,
      ));
}
