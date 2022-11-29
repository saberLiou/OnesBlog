import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'user_auth_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  UserAuthCubit({
    required this.userRepository,
  }) : super(const UserAuthState());

  final UserRepository userRepository;

  void init() => emit(
        state.copyWith(
          status: BlocCubitStatus.initial,
          unverifiedEmail: userRepository.getEmail(),
        ),
      );

  void setTab({required bool loginTab}) => emit(
        state.copyWith(
          status: BlocCubitStatus.initial,
          loginTab: loginTab,
        ),
      );

  Future<void> resetForm({bool registerAgain = false}) async {
    if (registerAgain) {
      await userRepository.setEmail(null);
      emit(
        state.copyWith(
          status: BlocCubitStatus.initial,
          unverifiedEmail: userRepository.getEmail(),
        ),
      );
    } else {
      emit(state.copyWith(status: BlocCubitStatus.initial));
    }
  }

  Future<void> submit({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      if (state.loginTab) {
        await userRepository.login(
          email: email,
          password: password,
        );
      } else {
        await userRepository.register(
          email: email,
          username: username,
          password: password,
        );
      }

      emit(
        state.copyWith(
          status: BlocCubitStatus.success,
          unverifiedEmail: userRepository.getEmail(),
        ),
      );
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
