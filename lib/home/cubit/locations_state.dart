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

  @override
  List<Object?> get props => [status, locations, currentPage];
}
