part of 'post_store_cubit.dart';

class PostStoreState extends Equatable {
  const PostStoreState({
    this.status = BlocCubitStatus.initial,
    this.post,
    this.locationCategory = LocationCategory.restaurants,
    this.locationId,
    this.locationName = '',
  });

  final BlocCubitStatus status;
  final Post? post;
  final LocationCategory locationCategory;
  final int? locationId;
  final String locationName;

  PostStoreState copyWith({
    BlocCubitStatus? status,
    Post? post,
    LocationCategory? locationCategory,
    int? locationId,
    String? locationName,
  }) =>
      PostStoreState(
        status: status ?? this.status,
        post: post ?? this.post,
        locationCategory: locationCategory ?? this.locationCategory,
        locationId: locationId ?? this.locationId,
        locationName: locationName ?? this.locationName,
      );

  @override
  List<Object?> get props => [
        status,
        post,
        locationCategory,
        locationId,
        locationName,
      ];
}
