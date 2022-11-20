part of 'post_show_cubit.dart';

class PostShowState extends Equatable {
  const PostShowState({
    this.initStatus = BlocCubitStatus.initial,
    this.status = BlocCubitStatus.initial,
    this.isLogin = false,
    required this.post,
    this.isAuthor = false,
    this.authUserKept = false,
    this.deleting = false,
  });

  final BlocCubitStatus initStatus;
  final BlocCubitStatus status;
  final bool isLogin;
  final Post post;
  final bool isAuthor;
  final bool authUserKept;
  final bool deleting;

  PostShowState copyWith({
    BlocCubitStatus? initStatus,
    BlocCubitStatus? status,
    bool? isLogin,
    Post? post,
    bool? isAuthor,
    bool? authUserKept,
    bool? deleting,
  }) =>
      PostShowState(
        initStatus: initStatus ?? this.initStatus,
        status: status ?? this.status,
        isLogin: isLogin ?? this.isLogin,
        post: post ?? this.post,
        isAuthor: isAuthor ?? this.isAuthor,
        authUserKept: authUserKept ?? this.authUserKept,
        deleting: deleting ?? this.deleting,
      );

  @override
  List<Object> get props => [
        initStatus,
        status,
        isLogin,
        post,
        isAuthor,
        authUserKept,
        deleting,
      ];
}
