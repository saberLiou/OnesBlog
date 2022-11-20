import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/data/models/location_score.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/data/models/user.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/domain/location_score_repository.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'user_show_state.dart';

class UserShowCubit extends Cubit<UserShowState> {
  UserShowCubit({
    required this.userRepository,
    required this.locationRepository,
    required this.locationScoreRepository,
    required this.postRepository,
    required User user,
  }) : super(UserShowState(user: user));

  final UserRepository userRepository;
  final LocationRepository locationRepository;
  final LocationScoreRepository locationScoreRepository;
  final PostRepository postRepository;

  Future<void> init() async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      final posts = await postRepository.listPosts(userId: state.user.id);
      final likedLocations = await locationRepository.listLocationLikes(
        state.user.id,
      );
      final keptPosts = await postRepository.listPostKeeps(
        state.user.id,
      );
      final locationScores = await locationScoreRepository.listLocationScores(
        userId: state.user.id,
      );
      emit(
        state.copyWith(
          status: BlocCubitStatus.success,
          posts: posts,
          likedLocations: likedLocations,
          keptPosts: keptPosts,
          locationScores: locationScores,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }

  void refreshUser() => emit(
        state.copyWith(
          initStatus: BlocCubitStatus.initial,
          user: userRepository.getUser(),
        ),
      );
}
