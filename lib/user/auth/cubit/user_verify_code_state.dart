part of 'user_verify_code_cubit.dart';

class UserVerifyCodeState extends Equatable {
  const UserVerifyCodeState({
    this.status = BlocCubitStatus.initial,
    required this.registerFlow,
    required this.email,
    this.verifyingCode = false,
  });

  final BlocCubitStatus status;
  final bool registerFlow;
  final String email;
  final bool verifyingCode;

  UserVerifyCodeState copyWith({
    BlocCubitStatus? status,
    bool? registerFlow,
    String? email,
    bool? verifyingCode,
  }) =>
      UserVerifyCodeState(
        status: status ?? this.status,
        registerFlow: registerFlow ?? this.registerFlow,
        email: email ?? this.email,
        verifyingCode: verifyingCode ?? this.verifyingCode,
      );

  @override
  List<Object> get props => [
        status,
        registerFlow,
        email,
        verifyingCode,
      ];
}
