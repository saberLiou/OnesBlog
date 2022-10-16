part of 'locations_cubit.dart';

class LocationsState extends Equatable {
  const LocationsState({
    this.status = BlocCubitStatus.initial,
    this.locations,
    this.currentPage = 0,
  });

  final BlocCubitStatus status;
  final List<Location>? locations;
  final int currentPage;

  LocationsState copyWith({
    BlocCubitStatus? status,
    List<Location>? locations,
    int? currentPage,
  }) =>
      LocationsState(
        status: status ?? this.status,
        locations: locations ?? this.locations,
        currentPage: currentPage ?? this.currentPage,
      );

  @override
  List<Object?> get props => [status, locations, currentPage];
}
