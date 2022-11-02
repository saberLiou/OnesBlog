import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/user.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';

part 'user_show_state.dart';

class UserShowCubit extends Cubit<UserShowState> {
  UserShowCubit({
    required this.userRepository,
    required User user,
  }) : super(UserShowState(user: user));

  final UserRepository userRepository;

  void refreshUser() => emit(
    state.copyWith(
        initStatus: BlocCubitStatus.initial,
        user: userRepository.getUser(),
    ),
  );
}
