part of 'user_show_cubit.dart';

class UserShowState extends Equatable {
  const UserShowState({
    this.initStatus = BlocCubitStatus.initial,
    this.status = BlocCubitStatus.initial,
    required this.user,
    this.tab = 0,
    this.posts,
    this.likedLocations,
    this.keptPosts,
    this.locationScores,
  });

  final BlocCubitStatus initStatus;
  final BlocCubitStatus status;
  final User user;
  final int tab;
  final List<Post>? posts;
  final List<Location>? likedLocations;
  final List<Post>? keptPosts;
  final List<LocationScore>? locationScores;

  UserShowState copyWith({
    BlocCubitStatus? initStatus,
    BlocCubitStatus? status,
    User? user,
    int? tab,
    List<Post>? posts,
    List<Location>? likedLocations,
    List<Post>? keptPosts,
    List<LocationScore>? locationScores,
  }) =>
      UserShowState(
        initStatus: initStatus ?? this.initStatus,
        status: status ?? this.status,
        user: user ?? this.user,
        tab: tab ?? this.tab,
        posts: posts ?? this.posts,
        likedLocations: likedLocations ?? this.likedLocations,
        keptPosts: keptPosts ?? this.keptPosts,
        locationScores: locationScores ?? this.locationScores,
      );

  @override
  List<Object?> get props => [
        initStatus,
        status,
        user,
        tab,
        posts,
        likedLocations,
        keptPosts,
        locationScores,
      ];
}
