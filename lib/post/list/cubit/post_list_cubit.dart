import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';

part 'post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  PostListCubit({
    required this.postRepository,
    required this.userRepository,
  }) : super(const PostListState());

  final PostRepository postRepository;
  final UserRepository userRepository;

  Future<void> init() async => fetchPosts(
        isLogin: userRepository.getToken() != null,
      );

  Future<void> fetchPosts({
    LocationCategory category = LocationCategory.restaurants,
    int limit = 10,
    bool? isLogin,
  }) async {
    emit(
      state.copyWith(
        status: BlocCubitStatus.loading,
        tab: category,
        isLogin: isLogin ?? state.isLogin,
      ),
    );

    try {
      final posts = await postRepository.listPosts(
        categoryId: category.id,
        limit: limit,
      );
      emit(
        state.copyWith(
          status: BlocCubitStatus.success,
          posts: posts,
          isLogin: isLogin ?? state.isLogin,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: BlocCubitStatus.failure,
          isLogin: isLogin ?? state.isLogin,
        ),
      );
    }
  }
}
