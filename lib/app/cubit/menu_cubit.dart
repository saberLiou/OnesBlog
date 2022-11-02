import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/data/models/user.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/user_login_type.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit({
    required this.userRepository,
  }) : super(const MenuState());

  final UserRepository userRepository;

  Future<void> init() async {
    final isLogin = userRepository.getToken() != null,
        user = userRepository.getUser();
    if (isLogin) {
      emit(
        state.copyWith(
          initStatus: BlocCubitStatus.loading,
          isLogin: isLogin,
          user: user,
          userLocation: user?.location,
          loginType: UserLoginType.getById(user?.loginTypeId),
          loginTypeChanged: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          initStatus: BlocCubitStatus.loading,
          loginTypeChanged: false,
        ),
      );
    }

    try {
      if (isLogin &&
          state.user?.locationAppliedAt != null &&
          state.userLocation == null) {
        final authUser = await userRepository.getAuthUser();
        emit(
          state.copyWith(
            initStatus: BlocCubitStatus.success,
            user: authUser,
            userLocation: authUser?.location,
          ),
        );
      }
    } on Exception {
      emit(state.copyWith(initStatus: BlocCubitStatus.failure));
    }
  }

  Future<void> switchAccount() async {
    emit(
      state.copyWith(
        status: BlocCubitStatus.loading,
        loginTypeChanged: true,
      ),
    );

    try {
      final loginType = state.loginType == UserLoginType.user
          ? UserLoginType.location
          : UserLoginType.user;
      await userRepository.update(loginType: loginType);
      emit(
        state.copyWith(
          status: BlocCubitStatus.success,
          loginType: loginType,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }

  Future<void> removeToken() async {
    emit(
      state.copyWith(
        status: BlocCubitStatus.loading,
        isLogin: false,
        loginType: UserLoginType.user,
        loginTypeChanged: false,
      ),
    );

    try {
      await userRepository.logout();
      emit(state.copyWith(status: BlocCubitStatus.success));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
