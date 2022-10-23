import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit({
    required this.userRepository,
  }) : super(const MenuState());

  final UserRepository userRepository;

  void init() => emit(
        state.copyWith(isLogin: userRepository.getToken() != null),
      );

  Future<void> removeToken() async {
    emit(state.copyWith(status: BlocCubitStatus.loading));

    try {
      await userRepository.logout();
      emit(state.copyWith(status: BlocCubitStatus.success, isLogin: false));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure, isLogin: false));
    }
  }
}
