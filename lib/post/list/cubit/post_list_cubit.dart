import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  PostListCubit() : super(const PostListState());
}
