import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'user_forget_password_state.dart';

class UserForgetPasswordCubit extends Cubit<UserForgetPasswordState> {
  UserForgetPasswordCubit({
    required this.userRepository,
  }) : super(const UserForgetPasswordState());

  final UserRepository userRepository;

  Future<void> submit(String email) async {
    emit(state.copyWith(status: BlocCubitStatus.loading));
    try {
      await userRepository.sendVerificationCode(
        email: email,
        registerFlow: false,
      );
      emit(state.copyWith(status: BlocCubitStatus.success));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
