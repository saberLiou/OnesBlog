part of 'location_store_cubit.dart';

class LocationStoreState extends Equatable {
  const LocationStoreState({
    this.initStatus = BlocCubitStatus.initial,
    this.status = BlocCubitStatus.initial,
    this.location,
    this.locationCategory = LocationCategory.restaurants,
    this.cities,
    this.cityId,
    this.cityAreas,
    this.cityAreaId,
  });

  final BlocCubitStatus initStatus;
  final BlocCubitStatus status;
  final Location? location;
  final LocationCategory locationCategory;
  final List<City>? cities;
  final int? cityId;
  final List<CityArea>? cityAreas;
  final int? cityAreaId;

  LocationStoreState copyWith({
    BlocCubitStatus? initStatus,
    BlocCubitStatus? status,
    Location? location,
    LocationCategory? locationCategory,
    List<City>? cities,
    int? cityId,
    List<CityArea>? cityAreas,
    int? cityAreaId,
  }) =>
      LocationStoreState(
        initStatus: initStatus ?? this.initStatus,
        status: status ?? this.status,
        location: location ?? this.location,
        locationCategory: locationCategory ?? this.locationCategory,
        cities: cities ?? this.cities,
        cityId: cityId ?? this.cityId,
        cityAreas: cityAreas ?? this.cityAreas,
        cityAreaId: cityAreaId != -1 ? cityAreaId ?? this.cityAreaId : null,
      );

  @override
  List<Object?> get props => [
        initStatus,
        status,
        location,
        locationCategory,
        cities,
        cityId,
        cityAreas,
        cityAreaId,
      ];
}
