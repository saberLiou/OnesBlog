import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';

part 'post_store_state.dart';

class PostStoreCubit extends Cubit<PostStoreState> {
  PostStoreCubit({
    required this.userRepository,
    required this.postRepository,
    Post? post,
  }) : super(PostStoreState(post: post));

  final UserRepository userRepository;
  final PostRepository postRepository;

  void init() {
    final location = state.post?.location;
    if (location != null) {
      setLocationName(
        locationId: location.id,
        locationName: location.name,
      );
    }
  }

  void selectLocationCategory(LocationCategory locationCategory) =>
      emit(state.copyWith(locationCategory: locationCategory));

  void setLocationName({
    required int locationId,
    required String locationName,
  }) =>
      emit(
        state.copyWith(
          locationId: locationId,
          locationName: locationName,
        ),
      );

  Future<void> submit({
    required String title,
    String? content,
  }) async {
    emit(state.copyWith(status: BlocCubitStatus.loading));
    try {
      await postRepository.store(
        id: state.post?.id,
        token: userRepository.getToken(),
        locationId: state.locationId!,
        title: title,
        content: content,
      );
      emit(state.copyWith(status: BlocCubitStatus.success));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
