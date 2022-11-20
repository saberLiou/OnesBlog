import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/data/models/location_score.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/data/models/user.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/domain/location_score_repository.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/post/list/widgets/post_card.dart';
import 'package:ones_blog/user/show/cubit/user_show_cubit.dart';
import 'package:ones_blog/user/update/user_update.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/size_handler.dart';

class UserShowPage extends StatelessWidget {
  const UserShowPage({super.key});

  static Route<UserShowPage> route(User user) => MaterialPageRoute(
        builder: (context) => BlocProvider<UserShowCubit>.value(
          value: UserShowCubit(
            userRepository: context.read<UserRepository>(),
            locationRepository: context.read<LocationRepository>(),
            locationScoreRepository: context.read<LocationScoreRepository>(),
            postRepository: context.read<PostRepository>(),
            user: user,
          )..init(),
          child: const UserShowPage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const UserShowView();
}

class UserShowView extends StatefulWidget {
  const UserShowView({super.key});

  @override
  State createState() => _UserShowViewState();
}

class _UserShowViewState extends State<UserShowView> {
  /// A method that launches the [UserUpdatePage],
  /// and awaits for Navigator.pop.
  Future<void> _navigateUserUpdatePage(BuildContext context) async {
    /// Navigator.push returns a Future that completes after calling
    /// Navigator.pop on the UserUpdatePage Screen.
    final result = await Navigator.push(
      context,
      UserUpdatePage.route(),
    );

    /// When a BuildContext is used from a StatefulWidget, the mounted property
    /// must be checked after an asynchronous gap.
    if (!mounted) return;

    if (result?.page == PoppedFromPage.updateUser &&
        (result!.arguments?['submitted'] as bool? ?? false)) {
      context.read<UserShowCubit>().refreshUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userShowCubit = context.read<UserShowCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          endDrawer: const MenuView(),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              FixedAppBar(
                toolbarHeight: SpaceUnit.base * 34,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Column(
                    children: [
                      BlocBuilder<UserShowCubit, UserShowState>(
                        builder: (context, state) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        'images/element/member.png',
                                      ),
                                    ),
                                  ),
                                ),
                                Text(state.user.name),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  '我的文章',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 5),
                                Text((state.posts?.length).toString()),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  '喜好店家',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 5),
                                Text((state.likedLocations?.length).toString()),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  '珍藏文章',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 5),
                                Text((state.keptPosts?.length).toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 90, bottom: 10),
                            child: AppButton(
                              height: SpaceUnit.base * 6,
                              width: SizeHandler.screenWidth / 2.5,
                              title: '編輯個人資訊',
                              onPressed: () => _navigateUserUpdatePage(context),
                            ),
                          )
                        ],
                      ),
                      TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.blueGrey,
                        onTap: (index) {
                          switch (index) {
                            case 0:
                              break;
                            case 1:
                              break;
                            case 2:
                              break;
                            case 3:
                              break;
                          }
                        },
                        tabs: const [
                          Tab(
                            child: Image(
                              image: AssetImage(
                                'images/element/article.png',
                              ),
                            ),
                          ),
                          Tab(
                            child: Image(
                              image: AssetImage(
                                'images/element/like.png',
                              ),
                            ),
                          ),
                          Tab(
                            child: Image(
                              image: AssetImage(
                                'images/element/keep.png',
                              ),
                            ),
                          ),
                          Tab(
                            child: Image(
                              image: AssetImage(
                                'images/element/score.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    color: AppColors.primary,
                    height: SizeHandler.screenHeight + 600,
                    width: SizeHandler.screenWidth,
                    child: BlocBuilder<UserShowCubit, UserShowState>(
                      builder: (context, state) => Column(
                        children: [
                          for (final post in state.posts ?? <Post>[]) ...[
                            PostCard(post: post),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                // ),
                SingleChildScrollView(
                  child: Container(
                    color: AppColors.primary,
                    height: SizeHandler.screenHeight + 600,
                    width: SizeHandler.screenWidth,
                    child: BlocBuilder<UserShowCubit, UserShowState>(
                      builder: (context, state) => Column(
                        children: [
                          for (final location
                              in state.likedLocations ?? <Location>[]) ...[
                            ListTile(
                              title: Text(
                                location.name,
                                style: AppTextStyle.content,
                              ),
                              subtitle: Text(location.cityAndArea ?? ''),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    color: AppColors.primary,
                    height: SizeHandler.screenHeight + 600,
                    width: SizeHandler.screenWidth,
                    child: BlocBuilder<UserShowCubit, UserShowState>(
                      builder: (context, state) => Column(
                        children: [
                          for (final post in state.keptPosts ?? <Post>[]) ...[
                            PostCard(post: post),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    color: AppColors.primary,
                    height: SizeHandler.screenHeight + 600,
                    width: SizeHandler.screenWidth,
                    child: BlocBuilder<UserShowCubit, UserShowState>(
                      builder: (context, state) => Column(
                        children: [
                          for (final score
                              in state.locationScores ?? <LocationScore>[]) ...[
                            ListTile(
                              title: Text(
                                score.location.name,
                                style: AppTextStyle.content,
                              ),
                              subtitle: Text(score.score.toString()),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
