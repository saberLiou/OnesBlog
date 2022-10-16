part of 'user_auth_cubit.dart';

class UserAuthState extends Equatable {
  const UserAuthState({
    this.status = BlocCubitStatus.initial,
    this.loginTab = true,
  });

  final BlocCubitStatus status;
  final bool loginTab;

  UserAuthState copyWith({
    BlocCubitStatus? status,
    bool? loginTab,
  }) =>
      UserAuthState(
        status: status ?? this.status,
        loginTab: loginTab ?? this.loginTab,
      );

  @override
  List<Object?> get props => [status, loginTab];
}
