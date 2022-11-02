import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/post/list/post_list.dart';
import 'package:ones_blog/post/list/widgets/post_card.dart';
import 'package:ones_blog/post/store/post_store.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  static Route<PostListPage> route() => MaterialPageRoute(
        builder: (context) => const PostListPage(),
      );

  @override
  Widget build(BuildContext context) => BlocProvider<PostListCubit>.value(
        value: PostListCubit(
          postRepository: context.read<PostRepository>(),
          userRepository: context.read<UserRepository>(),
        )..init(),
        child: const PostListView(),
      );
}

class PostListView extends StatefulWidget {
  const PostListView({super.key});

  @override
  State createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  /// A method that launches the [PostStorePage],
  /// and awaits for Navigator.pop.
  Future<void> _navigatePostStorePage(BuildContext context) async {
    /// Navigator.push returns a Future that completes after calling
    /// Navigator.pop on the PostStorePage Screen.
    final result = await Navigator.push(
      context,
      PostStorePage.route(null),
    );

    /// When a BuildContext is used from a StatefulWidget, the mounted property
    /// must be checked after an asynchronous gap.
    if (!mounted) return;

    if (result?.page == PoppedFromPage.addPost) {
      final postListCubit = context.read<PostListCubit>();
      final locationCategory = (result?.arguments?['locationCategory'] ??
          postListCubit.state.tab) as LocationCategory;
      DefaultTabController.of(context)?.animateTo(locationCategory.id - 1);
      await postListCubit.fetchPosts(category: locationCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final postListCubit = context.read<PostListCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          endDrawer: const MenuView(),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              FixedAppBar(
                toolbarHeight: SpaceUnit.base * 22,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: SpaceUnit.threeQuarterBase,
                            ),
                            child: Image.asset(
                              'images/text/communityWord.png',
                              height: 55,
                            ),
                          ),
                        ],
                      ),
                      TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.blueGrey,
                        onTap: (index) {
                          switch (index) {
                            case 0:
                              postListCubit.fetchPosts();
                              break;
                            case 1:
                              postListCubit.fetchPosts(
                                category: LocationCategory.spots,
                              );
                              break;
                            case 2:
                              postListCubit.fetchPosts(
                                category: LocationCategory.lodgings,
                              );
                              break;
                          }
                        },
                        tabs: LocationCategory.values
                            .map(
                              (category) => Tab(
                                child: Text(
                                  category.translate(l10n),
                                  style: AppTextStyle.content,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              children: LocationCategory.values
                  .map(
                    (category) => SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height + 350,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 5,
                          ),
                          color: AppColors.primary,
                        ),
                        child: _Content(),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 4,
            onPressed: () => postListCubit.state.isLogin
                ? _navigatePostStorePage(context)
                : EasyLoading.showInfo(
                    l10n.loginFirstTo(l10n.addPost.toLowerCase()),
                    duration: AppDuration.medium,
                  ),
            backgroundColor: Colors.white,
            child: const Icon(
              FontAwesomeIcons.plus,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((PostListCubit cubit) => cubit.state.status);

    switch (status) {
      case BlocCubitStatus.initial:
        return const SizedBox(
          key: Key('content_initial_sizedBox'),
        );
      case BlocCubitStatus.loading:
        return const Center(
          key: Key('content_loading_indicator'),
          child: CircularProgressIndicator.adaptive(),
        );
      case BlocCubitStatus.success:
        return const _PostListTiles(
          key: Key('content_success_carouselSlider'),
        );
      case BlocCubitStatus.failure:
        return Center(
          key: const Key('content_failure_text'),
          child: Text(l10n.listFetchErrorMessage),
        );
    }
  }
}

class _PostListTiles extends StatelessWidget {
  const _PostListTiles({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PostListCubit, PostListState>(
        builder: (context, state) => Column(
          children: [
            for (final post in state.posts!) ...[
              PostCard(post: post),
            ],
          ],
        ),
      );
}
