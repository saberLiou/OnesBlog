part of 'user_show_cubit.dart';

class UserShowState extends Equatable {
  const UserShowState({
    this.initStatus = BlocCubitStatus.initial,
    this.status = BlocCubitStatus.initial,
    required this.user,
  });

  final BlocCubitStatus initStatus;
  final BlocCubitStatus status;
  final User user;

  UserShowState copyWith({
    BlocCubitStatus? initStatus,
    BlocCubitStatus? status,
    User? user,
  }) =>
      UserShowState(
        initStatus: initStatus ?? this.initStatus,
        status: status ?? this.status,
        user: user ?? this.user,
      );

  @override
  List<Object> get props => [initStatus, status, user];
}
