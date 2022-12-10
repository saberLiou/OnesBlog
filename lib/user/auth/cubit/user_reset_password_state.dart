part of 'user_reset_password_cubit.dart';

class UserResetPasswordState extends Equatable {
  const UserResetPasswordState({
    this.status = BlocCubitStatus.initial,
  });

  final BlocCubitStatus status;

  UserResetPasswordState copyWith({
    BlocCubitStatus? status,
  }) =>
      UserResetPasswordState(
        status: status ?? this.status,
      );

  @override
  List<Object> get props => [status];
}
