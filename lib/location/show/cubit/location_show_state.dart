part of 'location_show_cubit.dart';

class LocationShowState extends Equatable {
  const LocationShowState({
    this.initStatus = BlocCubitStatus.initial,
    this.status = BlocCubitStatus.initial,
    this.isLogin = false,
    this.fromMenu = false,
    required this.location,
    this.posts,
    this.authUserLiked = false,
    this.score = 0,
    this.submittingRate = false,
  });

  final BlocCubitStatus initStatus;
  final BlocCubitStatus status;
  final bool isLogin;
  final bool fromMenu;
  final Location location;
  final List<Post>? posts;
  final bool authUserLiked;
  final double score;
  final bool submittingRate;

  LocationShowState copyWith({
    BlocCubitStatus? initStatus,
    BlocCubitStatus? status,
    bool? isLogin,
    bool? fromMenu,
    Location? location,
    List<Post>? posts,
    bool? authUserLiked,
    double? score,
    bool? submittingRate,
  }) =>
      LocationShowState(
        initStatus: initStatus ?? this.initStatus,
        status: status ?? this.status,
        isLogin: isLogin ?? this.isLogin,
        fromMenu: fromMenu ?? this.fromMenu,
        location: location ?? this.location,
        posts: posts ?? this.posts,
        authUserLiked: authUserLiked ?? this.authUserLiked,
        score: score ?? this.score,
        submittingRate: submittingRate ?? this.submittingRate,
      );

  @override
  List<Object?> get props => [
        initStatus,
        status,
        isLogin,
        fromMenu,
        location,
        posts,
        authUserLiked,
        score,
        submittingRate,
      ];
}
