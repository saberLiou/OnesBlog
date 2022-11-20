import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/domain/post_keep_repository.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/post/list/post_list.dart';
import 'package:ones_blog/post/show/post_show.dart';
import 'package:ones_blog/post/store/post_store.dart';
import 'package:ones_blog/post/store/view/post_store_page.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';
import 'package:ones_blog/utils/size_handler.dart';

class PostShowPage extends StatelessWidget {
  const PostShowPage({super.key});

  static Route<PostShowPage> route(Post post) => MaterialPageRoute(
        builder: (context) => BlocProvider<PostShowCubit>.value(
          value: PostShowCubit(
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
            postKeepRepository: context.read<PostKeepRepository>(),
            post: post,
          )..init(),
          child: const PostShowPage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const PostShowView();
}

class PostShowView extends StatelessWidget {
  const PostShowView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final postShowCubit = context.read<PostShowCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: const MenuView(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            const FixedAppBar(
              homeLeadingIcon: false,
            ),
          ],
          body: BlocConsumer<PostShowCubit, PostShowState>(
              listener: (context, state) {
                switch (state.status) {
                  case BlocCubitStatus.initial:
                    break;
                  case BlocCubitStatus.loading:
                    if (state.deleting) {
                      EasyLoading.show(status: l10n.deletingMessage);
                    }
                    break;
                  case BlocCubitStatus.success:
                  case BlocCubitStatus.failure:
                    if (state.deleting) {
                      EasyLoading.showSuccess(
                        l10n.deletedSuccessMessage,
                        duration: AppDuration.short,
                      );
                      Navigator.pushReplacement(
                        context,
                        PostListPage.route(),
                      );
                    }
                    break;
                }
              },
              builder: (context, state) => SingleChildScrollView(
                    child: Container(
                      color: AppColors.primary,
                      height: SizeHandler.screenHeight,
                      width: SizeHandler.screenWidth,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/element/member.png',
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      state.post.user!.name,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        l10n.categorySection(
                                          LocationCategory.getById(
                                            state.post.location?.categoryId,
                                          ).translate(l10n),
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                if (!state.isAuthor)
                                  if (state.isLogin)
                                    IconButton(
                                      isSelected: false,
                                      onPressed: postShowCubit.keep,
                                      icon: Icon(
                                        postShowCubit.state.authUserKept
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                    )
                                  else
                                    Container()
                                else
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          PostStorePage.route(state.post),
                                        ),
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 40,
                                          color: Colors.black,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => context
                                            .read<PostShowCubit>()
                                            .delete(),
                                        icon: const Icon(
                                          Icons.restore_from_trash,
                                          size: 40,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Text(state.post.title),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                Text(state.post.location!.name),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, left: 40, right: 40),
                            child: Text(state.post.content ?? ''),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: SpaceUnit.base * 15,
                                right: SpaceUnit.base * 18),
                            child: Text(state.post.publishedAt),
                          ),
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
