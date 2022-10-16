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

  Future<void> getToken() async =>
      emit(state.copyWith(token: userRepository.getToken()));

  Future<void> removeToken() async {
    emit(state.copyWith(status: BlocCubitStatus.loading, token: state.token));

    try {
      await userRepository.logout();
      emit(state.copyWith(status: BlocCubitStatus.success, token: null));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure, token: null));
    }
  }
}
