part of 'user_auth_cubit.dart';

class UserAuthState extends Equatable {
  const UserAuthState({
    this.status = BlocCubitStatus.initial,
    this.loginTab = true,
    this.unverifiedEmail,
  });

  final BlocCubitStatus status;
  final bool loginTab;
  final String? unverifiedEmail;
  bool get emailUnverified => unverifiedEmail != null;

  UserAuthState copyWith({
    BlocCubitStatus? status,
    bool? loginTab,
    String? unverifiedEmail,
  }) =>
      UserAuthState(
        status: status ?? this.status,
        loginTab: loginTab ?? this.loginTab,
        unverifiedEmail: unverifiedEmail ?? this.unverifiedEmail,
      );

  @override
  List<Object?> get props => [status, loginTab, unverifiedEmail];
}
