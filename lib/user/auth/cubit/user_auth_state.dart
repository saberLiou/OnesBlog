part of 'user_auth_cubit.dart';

class UserAuthState extends Equatable {
  const UserAuthState({
    this.status = BlocCubitStatus.initial,
    this.resettingForm = false,
    this.loginTab = true,
    this.unverifiedEmail = '',
  });

  final BlocCubitStatus status;
  final bool resettingForm;
  final bool loginTab;
  final String unverifiedEmail;

  bool get emailUnverified => unverifiedEmail != '';

  UserAuthState copyWith({
    BlocCubitStatus? status,
    bool? resettingForm,
    bool? loginTab,
    String? unverifiedEmail,
  }) =>
      UserAuthState(
        status: status ?? this.status,
        resettingForm: resettingForm ?? this.resettingForm,
        loginTab: loginTab ?? this.loginTab,
        unverifiedEmail: unverifiedEmail ?? this.unverifiedEmail,
      );

  @override
  List<Object?> get props => [
        status,
        resettingForm,
        loginTab,
        unverifiedEmail,
      ];
}
