import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ones_blog/post/list/post_list.dart';
import 'package:ones_blog/post/list/view/post_list_view.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  static Route<PostListPage> route() => MaterialPageRoute(
        builder: (context) => const PostListPage(),
      );

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => PostListCubit(),
        child: const PostListView(),
      );
}
