part of 'user_verify_code_cubit.dart';

class UserVerifyCodeState extends Equatable {
  const UserVerifyCodeState({
    this.status = BlocCubitStatus.initial,
    required this.email,
  });

  final BlocCubitStatus status;
  final String email;

  UserVerifyCodeState copyWith({
    BlocCubitStatus? status,
    String? email,
  }) =>
      UserVerifyCodeState(
        status: status ?? this.status,
        email: email ?? this.email,
      );

  @override
  List<Object> get props => [status, email];
}
