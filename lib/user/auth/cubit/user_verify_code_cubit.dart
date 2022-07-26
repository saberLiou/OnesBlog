import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'user_verify_code_state.dart';

class UserVerifyCodeCubit extends Cubit<UserVerifyCodeState> {
  UserVerifyCodeCubit({
    required this.userRepository,
    required bool registerFlow,
    required String email,
  }) : super(UserVerifyCodeState(registerFlow: registerFlow, email: email));

  final UserRepository userRepository;

  Future<void> resendVerificationCode() async {
    emit(state.copyWith(status: BlocCubitStatus.loading, verifyingCode: false));
    try {
      await userRepository.sendVerificationCode(
        registerFlow: state.registerFlow,
        email: state.email,
      );
      emit(state.copyWith(status: BlocCubitStatus.success));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }

  Future<void> submit(String code) async {
    emit(state.copyWith(status: BlocCubitStatus.loading, verifyingCode: true));
    try {
      await userRepository.verifyCode(
        registerFlow: state.registerFlow,
        email: state.email,
        code: code,
      );
      emit(state.copyWith(status: BlocCubitStatus.success));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
