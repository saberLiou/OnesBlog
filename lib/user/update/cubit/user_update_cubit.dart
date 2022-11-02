import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/user.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'user_update_state.dart';

class UserUpdateCubit extends Cubit<UserUpdateState> {
  UserUpdateCubit({
    required this.userRepository,
  }) : super(UserUpdateState(user: userRepository.getUser()!));

  final UserRepository userRepository;

  Future<void> submit({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      await userRepository.update(
        username: username,
        password: password.isNotEmpty ? password : null,
      );

      emit(state.copyWith(status: BlocCubitStatus.success));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
