part of 'user_forget_password_cubit.dart';

class UserForgetPasswordState extends Equatable {
  const UserForgetPasswordState({
    this.status = BlocCubitStatus.initial,
  });

  final BlocCubitStatus status;

  UserForgetPasswordState copyWith({
    BlocCubitStatus? status,
  }) =>
      UserForgetPasswordState(
        status: status ?? this.status,
      );

  @override
  List<Object> get props => [status];
}
