part of 'menu_cubit.dart';

class MenuState extends Equatable {
  const MenuState({
    this.status = BlocCubitStatus.initial,
    this.isLogin = false,
  });

  final BlocCubitStatus status;
  final bool isLogin;

  MenuState copyWith({
    BlocCubitStatus? status,
    bool? isLogin,
  }) =>
      MenuState(
        status: status ?? this.status,
        isLogin: isLogin ?? this.isLogin,
      );

  @override
  List<Object?> get props => [status, isLogin];
}
