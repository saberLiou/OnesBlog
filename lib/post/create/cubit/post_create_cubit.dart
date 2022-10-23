import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';

part 'post_create_state.dart';

class PostCreateCubit extends Cubit<PostCreateState> {
  PostCreateCubit({
    required this.userRepository,
    required this.postRepository,
  }) : super(const PostCreateState());

  final UserRepository userRepository;
  final PostRepository postRepository;

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
