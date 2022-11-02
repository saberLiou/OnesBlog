part of 'user_update_cubit.dart';

class UserUpdateState extends Equatable {
  const UserUpdateState({
    this.status = BlocCubitStatus.initial,
    required this.user,
  });

  final BlocCubitStatus status;
  final User user;

  UserUpdateState copyWith({
    BlocCubitStatus? status,
    User? user,
  }) =>
      UserUpdateState(
        status: status ?? this.status,
        user: user ?? this.user,
      );

  @override
  List<Object> get props => [status, user];
}
