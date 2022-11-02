part of 'locations_cubit.dart';

class LocationsState extends Equatable {
  const LocationsState({
    this.status = BlocCubitStatus.initial,
    required this.category,
    required this.random,
    required this.ranking,
    this.locations,
    this.currentPage = 0,
  });

  final BlocCubitStatus status;
  final LocationCategory category;
  final int? random;
  final int? ranking;
  final List<Location>? locations;
  final int currentPage;

  LocationsState copyWith({
    BlocCubitStatus? status,
    LocationCategory? category,
    int? random,
    int? ranking,
    List<Location>? locations,
    int? currentPage,
  }) =>
      LocationsState(
        status: status ?? this.status,
        category: category ?? this.category,
        random: random ?? this.random,
        ranking: ranking ?? this.ranking,
        locations: locations ?? this.locations,
        currentPage: currentPage ?? this.currentPage,
      );

  @override
  List<Object?> get props => [
        status,
        category,
        random,
        ranking,
        locations,
        currentPage,
      ];
}
