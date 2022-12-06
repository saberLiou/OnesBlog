part of 'user_verify_code_cubit.dart';

class UserVerifyCodeState extends Equatable {
  const UserVerifyCodeState({
    this.status = BlocCubitStatus.initial,
    required this.email,
    this.verifyingCode = false,
  });

  final BlocCubitStatus status;
  final String email;
  final bool verifyingCode;

  UserVerifyCodeState copyWith({
    BlocCubitStatus? status,
    String? email,
    bool? verifyingCode,
  }) =>
      UserVerifyCodeState(
        status: status ?? this.status,
        email: email ?? this.email,
        verifyingCode: verifyingCode ?? this.verifyingCode,
      );

  @override
  List<Object> get props => [status, email, verifyingCode];
}
