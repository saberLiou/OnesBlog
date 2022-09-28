import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ones_blog/post/list/post_list.dart';

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostListCubit>();
    return const Text('PostListPage');
  }
}
