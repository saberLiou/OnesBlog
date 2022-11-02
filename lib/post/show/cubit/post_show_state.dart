part of 'post_show_cubit.dart';

class PostShowState extends Equatable {
  const PostShowState({
    this.status = BlocCubitStatus.initial,
    required this.post,
    this.isAuthor = false,
  });

  final BlocCubitStatus status;
  final Post post;
  final bool isAuthor;

  PostShowState copyWith({
    BlocCubitStatus? status,
    Post? post,
    bool? isAuthor,
  }) =>
      PostShowState(
        status: status ?? this.status,
        post: post ?? this.post,
        isAuthor: isAuthor ?? this.isAuthor,
      );

  @override
  List<Object> get props => [status, post, isAuthor];
}
