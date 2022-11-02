part of 'location_list_cubit.dart';

class LocationListState extends Equatable {
  const LocationListState({
    this.status = BlocCubitStatus.initial,
    required this.locationCategory,
    this.cities,
    this.cityId = 10, // TODO: get by GPS
    this.locations,
  });

  final BlocCubitStatus status;
  final LocationCategory locationCategory;
  final List<City>? cities;
  final int cityId;
  final List<Location>? locations;

  LocationListState copyWith({
    BlocCubitStatus? status,
    LocationCategory? locationCategory,
    List<City>? cities,
    int? cityId,
    List<Location>? locations,
  }) =>
      LocationListState(
        status: status ?? this.status,
        locationCategory: locationCategory ?? this.locationCategory,
        cities: cities ?? this.cities,
        cityId: cityId ?? this.cityId,
        locations: locations ?? this.locations,
      );

  @override
  List<Object?> get props => [
        status,
        locationCategory,
        cities,
        cityId,
        locations,
      ];
}
