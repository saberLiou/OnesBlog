part of 'post_list_cubit.dart';

enum PostListStatus { initial, loading, success, failure }

class PostListState extends Equatable {
  const PostListState({this.status = PostListStatus.initial});

  final PostListStatus status;

  @override
  List<Object> get props => [status];
}
