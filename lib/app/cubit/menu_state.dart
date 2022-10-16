part of 'menu_cubit.dart';

class MenuState extends Equatable {
  const MenuState({
    this.status = BlocCubitStatus.initial,
    this.token,
  });

  final BlocCubitStatus status;
  final String? token;

  MenuState copyWith({
    BlocCubitStatus? status,
    required String? token,
  }) =>
      MenuState(
        status: status ?? this.status,
        token: token,
      );

  @override
  List<Object?> get props => [status, token];
}
