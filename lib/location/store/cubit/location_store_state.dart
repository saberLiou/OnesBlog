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
    this.images,
  });

  final BlocCubitStatus initStatus;
  final BlocCubitStatus status;
  final Location? location;

  bool get isEditing => location != null;
  final LocationCategory locationCategory;
  final List<City>? cities;
  final int? cityId;
  final List<CityArea>? cityAreas;
  final int? cityAreaId;
  final List<String>? images;

  LocationStoreState copyWith({
    BlocCubitStatus? initStatus,
    BlocCubitStatus? status,
    Location? location,
    LocationCategory? locationCategory,
    List<City>? cities,
    int? cityId,
    List<CityArea>? cityAreas,
    int? cityAreaId,
    List<String>? images,
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
        images: images ?? this.images,
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
        images,
      ];
}
