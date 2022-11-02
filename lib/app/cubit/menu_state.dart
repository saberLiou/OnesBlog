part of 'menu_cubit.dart';

class MenuState extends Equatable {
  const MenuState({
    this.initStatus = BlocCubitStatus.initial,
    this.status = BlocCubitStatus.initial,
    this.isLogin = false,
    this.user,
    this.userLocation,
    this.loginType = UserLoginType.user,
    this.loginTypeChanged = false,
  });

  final BlocCubitStatus initStatus;
  final BlocCubitStatus status;
  final bool isLogin;
  final User? user;
  final Location? userLocation;
  final UserLoginType loginType;
  final bool loginTypeChanged;

  MenuState copyWith({
    BlocCubitStatus? initStatus,
    BlocCubitStatus? status,
    bool? isLogin,
    User? user,
    Location? userLocation,
    UserLoginType? loginType,
    bool? loginTypeChanged,
  }) =>
      MenuState(
        initStatus: initStatus ?? this.initStatus,
        status: status ?? this.status,
        isLogin: isLogin ?? this.isLogin,
        user: user ?? this.user,
        userLocation: userLocation ?? this.userLocation,
        loginType: loginType ?? this.loginType,
        loginTypeChanged: loginTypeChanged ?? this.loginTypeChanged,
      );

  @override
  List<Object?> get props => [
        initStatus,
        status,
        isLogin,
        user,
        userLocation,
        loginType,
        loginTypeChanged,
      ];
}
