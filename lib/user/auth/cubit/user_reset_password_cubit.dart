import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'user_reset_password_state.dart';

class UserResetPasswordCubit extends Cubit<UserResetPasswordState> {
  UserResetPasswordCubit({
    required this.userRepository,
  }) : super(const UserResetPasswordState());

  final UserRepository userRepository;

  Future<void> submit(String password) async {
    emit(state.copyWith(status: BlocCubitStatus.loading));
    try {
      await userRepository.resetPassword(
        email: userRepository.getForgetEmail(),
        code: userRepository.getForgetCode(),
        password: password,
      );
      emit(state.copyWith(status: BlocCubitStatus.success));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
