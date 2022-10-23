part of 'post_list_cubit.dart';

class PostListState extends Equatable {
  const PostListState({
    this.status = BlocCubitStatus.initial,
    this.isLogin = false,
    this.tab = LocationCategory.restaurants,
    this.posts,
  });

  final BlocCubitStatus status;
  final bool isLogin;
  final LocationCategory tab;
  final List<Post>? posts;

  PostListState copyWith({
    BlocCubitStatus? status,
    bool? isLogin,
    LocationCategory? tab,
    List<Post>? posts,
  }) =>
      PostListState(
        status: status ?? this.status,
        isLogin: isLogin ?? this.isLogin,
        tab: tab ?? this.tab,
        posts: posts ?? this.posts,
      );

  @override
  List<Object?> get props => [status, isLogin, tab, posts];
}
