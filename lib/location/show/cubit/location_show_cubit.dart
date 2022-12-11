import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/data/models/location_score.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/domain/location_like_repository.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/domain/location_score_repository.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'location_show_state.dart';

class LocationShowCubit extends Cubit<LocationShowState> {
  LocationShowCubit({
    required this.userRepository,
    required Location location,
    required this.postRepository,
    required bool fromMenu,
    required this.locationScoreRepository,
    required this.locationLikeRepository,
    required this.locationRepository,
  }) : super(LocationShowState(location: location, fromMenu: fromMenu));

  final UserRepository userRepository;
  final PostRepository postRepository;
  final LocationScoreRepository locationScoreRepository;
  final LocationLikeRepository locationLikeRepository;
  final LocationRepository locationRepository;

  Future<void> init() async {
    final isLogin = userRepository.getToken() != null;
    emit(
      state.copyWith(
        initStatus: BlocCubitStatus.loading,
        isLogin: isLogin,
      ),
    );
    try {
      final locationScores = isLogin
          ? await locationScoreRepository.listLocationScores(
              locationId: state.location.id,
              userId: userRepository.getUser()!.id,
            )
          : <LocationScore>[];
      final likedLocation = (isLogin
              ? await locationRepository
                  .listLocationLikes(userRepository.getUser()!.id)
              : <Location>[])
          .firstWhereOrNull(
        (location) => location.id == state.location.id,
      );
      emit(
        state.copyWith(
          initStatus: BlocCubitStatus.success,
          authUserLiked: likedLocation != null,
          score: locationScores.isNotEmpty ? locationScores.first.score : 0,
        ),
      );
    } on Exception {
      emit(state.copyWith(initStatus: BlocCubitStatus.failure));
    }
  }

  void refreshLocation() => emit(
    state.copyWith(
      initStatus: BlocCubitStatus.initial,
      location: userRepository.getUser()!.location,
    ),
  );

  void setRate(double score) => emit(state.copyWith(score: score));

  Future<void> like() async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      await locationLikeRepository.store(
        locationId: state.location.id,
        token: userRepository.getToken(),
      );
      emit(
        state.copyWith(
          initStatus: BlocCubitStatus.success,
          authUserLiked: !state.authUserLiked,
        ),
      );
    } on Exception {
      emit(state.copyWith(initStatus: BlocCubitStatus.failure));
    }
  }

  Future<void> rate() async {
    emit(state.copyWith(status: BlocCubitStatus.loading, submittingRate: true));
    try {
      await locationScoreRepository.store(
        locationId: state.location.id,
        score: state.score,
        token: userRepository.getToken(),
      );

      final location = await locationRepository.getLocation(state.location.id);

      emit(
        state.copyWith(
          status: BlocCubitStatus.success,
          location: state.location.copyWith(avgScore: location?.avgScore),
          submittingRate: false,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: BlocCubitStatus.failure,
          submittingRate: false,
        ),
      );
    }
  }

  Future<void> fetchPosts({
    int limit = 10,
  }) async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      final posts = await postRepository.listPosts(
        categoryId: state.location.categoryId,
        locationId: state.location.id,
        limit: limit,
      );
      emit(
        state.copyWith(
          status: BlocCubitStatus.success,
          posts: posts,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
