import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/domain/post_keep_repository.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'post_show_state.dart';

class PostShowCubit extends Cubit<PostShowState> {
  PostShowCubit({
    required this.userRepository,
    required this.postRepository,
    required this.postKeepRepository,
    required Post post,
  }) : super(PostShowState(post: post));

  final UserRepository userRepository;
  final PostRepository postRepository;
  final PostKeepRepository postKeepRepository;

  Future<void> init() async {
    final isLogin = userRepository.getToken() != null,
        authUser = userRepository.getUser();
    emit(
      state.copyWith(
        initStatus: BlocCubitStatus.loading,
        isLogin: isLogin,
        isAuthor: authUser != null && authUser.id == state.post.user?.id,
      ),
    );

    try {
      final keptPost = (isLogin
              ? await postRepository.listPostKeeps(authUser!.id)
              : <Post>[])
          .firstWhereOrNull(
        (post) => post.id == state.post.id,
      );
      emit(
        state.copyWith(
          initStatus: BlocCubitStatus.success,
          authUserKept: keptPost != null,
        ),
      );
    } on Exception {
      emit(state.copyWith(initStatus: BlocCubitStatus.failure));
    }
  }

  Future<void> keep() async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      await postKeepRepository.store(
        postId: state.post.id,
        token: userRepository.getToken(),
      );
      emit(
        state.copyWith(
          initStatus: BlocCubitStatus.success,
          authUserKept: !state.authUserKept,
        ),
      );
    } on Exception {
      emit(state.copyWith(initStatus: BlocCubitStatus.failure));
    }
  }

  Future<void> delete() async {
    emit(state.copyWith(status: BlocCubitStatus.loading, deleting: true));

    try {
      await postRepository.delete(
        id: state.post.id,
        token: userRepository.getToken(),
      );
      emit(state.copyWith(status: BlocCubitStatus.success, deleting: true));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure, deleting: true));
    }
  }
}
