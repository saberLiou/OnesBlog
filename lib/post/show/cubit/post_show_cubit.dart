import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'post_show_state.dart';

class PostShowCubit extends Cubit<PostShowState> {
  PostShowCubit({
    required this.userRepository,
    required this.postRepository,
    required Post post,
  }) : super(PostShowState(post: post));

  final UserRepository userRepository;
  final PostRepository postRepository;

  void init() {
    final authUser = userRepository.getUser();

    emit(
      state.copyWith(
        isAuthor: authUser != null && authUser.id == state.post.user?.id,
      ),
    );
  }

  Future<void> delete() async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      await postRepository.delete(
        id: state.post.id,
        token: userRepository.getToken(),
      );
      emit(state.copyWith(status: BlocCubitStatus.success));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
