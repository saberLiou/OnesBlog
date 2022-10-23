part of 'post_create_cubit.dart';

class PostCreateState extends Equatable {
  const PostCreateState({
    this.status = BlocCubitStatus.initial,
    this.locationCategory = LocationCategory.restaurants,
    this.locationId,
    this.locationName = '',
  });

  final BlocCubitStatus status;
  final LocationCategory locationCategory;
  final int? locationId;
  final String locationName;

  PostCreateState copyWith({
    BlocCubitStatus? status,
    LocationCategory? locationCategory,
    int? locationId,
    String? locationName,
  }) =>
      PostCreateState(
        status: status ?? this.status,
        locationCategory: locationCategory ?? this.locationCategory,
        locationId: locationId ?? this.locationId,
        locationName: locationName ?? this.locationName,
      );

  @override
  List<Object?> get props => [
        status,
        locationCategory,
        locationId,
        locationName,
      ];
}
