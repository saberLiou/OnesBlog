import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/location_like_repository.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/domain/location_score_repository.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/location/show/location_show.dart';
import 'package:ones_blog/location/store/location_store.dart';
import 'package:ones_blog/location/store/view/location_store_page.dart';
import 'package:ones_blog/post/list/widgets/post_card.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';
import 'package:ones_blog/utils/size_handler.dart';

class LocationShowPage extends StatelessWidget {
  const LocationShowPage({super.key});

  static Route<PoppedFromPageArguments> route({
    required Location location,
    bool fromMenu = false,
  }) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider<LocationShowCubit>.value(
          value: LocationShowCubit(
            userRepository: context.read<UserRepository>(),
            location: location,
            postRepository: context.read<PostRepository>(),
            fromMenu: fromMenu,
            locationScoreRepository: context.read<LocationScoreRepository>(),
            locationLikeRepository: context.read<LocationLikeRepository>(),
            locationRepository: context.read<LocationRepository>(),
          )..init(),
          child: const LocationShowPage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const LocationShowView();
}

class LocationShowView extends StatefulWidget {
  const LocationShowView({super.key});

  @override
  State<StatefulWidget> createState() => _LocationShowViewState();
}

class _LocationShowViewState extends State<LocationShowView> {
  /// A method that launches the [LocationStorePage],
  /// and awaits for Navigator.pop.
  Future<void> _navigateLocationStorePage(
    BuildContext context,
    Location location,
  ) async {
    /// Navigator.push returns a Future that completes after calling
    /// Navigator.pop on the LocationStorePage Screen.
    final result = await Navigator.push(
      context,
      LocationStorePage.route(location),
    );

    /// When a BuildContext is used from a StatefulWidget, the mounted property
    /// must be checked after an asynchronous gap.
    if (!mounted) return;

    if (result?.page == PoppedFromPage.storeLocation &&
        (result!.arguments?['submitted'] as bool? ?? false)) {
      context.read<LocationShowCubit>().refreshLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locationShowCubit = context.read<LocationShowCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          endDrawer: const MenuView(),
          body: BlocConsumer<LocationShowCubit, LocationShowState>(
            listener: (context, state) {
              switch (state.status) {
                case BlocCubitStatus.initial:
                  break;
                case BlocCubitStatus.loading:
                  if (state.submittingRate) {
                    EasyLoading.show(
                      status: l10n.submittingMessage,
                    );
                  }
                  break;
                case BlocCubitStatus.success:
                case BlocCubitStatus.failure:
                  EasyLoading.dismiss();
                  break;
              }
            },
            builder: (context, state) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxScrolled) => [
                FixedAppBar(
                  homeLeadingIcon: state.fromMenu,
                  arguments: PoppedFromPageArguments(
                    page: PoppedFromPage.showLocation,
                  ),
                  toolbarHeight: SpaceUnit.base * 22,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 80),
                              child: Text(
                                state.location.name,
                                style: AppTextStyle.content,
                              ),
                            ),
                            if (!state.fromMenu)
                              if (state.isLogin)
                                IconButton(
                                  onPressed: locationShowCubit.like,
                                  icon: Icon(
                                    locationShowCubit.state.authUserLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 40,
                                  ),
                                )
                              else
                                Container()
                            else
                              IconButton(
                                onPressed: () => _navigateLocationStorePage(
                                  context,
                                  state.location,
                                ),
                                icon: const Icon(
                                  Icons.edit,
                                  size: 40,
                                  color: Colors.black,
                                ),
                              ),
                          ],
                        ),
                        TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Colors.blueGrey,
                          onTap: (index) {
                            switch (index) {
                              case 1:
                                locationShowCubit.fetchPosts();
                                break;
                            }
                          },
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                l10n.locationInformation,
                                style: AppTextStyle.content,
                              ),
                            ),
                            Tab(
                              child: Text(
                                l10n.locationPosts,
                                style: AppTextStyle.content,
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
                children: [
                  Container(
                    color: AppColors.primary,
                    height: SizeHandler.screenHeight + 600,
                    width: SizeHandler.screenWidth,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if ((state.location.images ?? []).isEmpty)
                            Container(
                              child: LocationCategory.getById(
                                state.location.categoryId,
                              ).defaultImage(),
                            )
                          else
                            CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                              ),
                              items: [
                                for (final image
                                    in state.location.images ?? <String>[]) ...[
                                  Image.network(image, fit: BoxFit.fill)
                                ],
                              ],
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RatingBar.builder(
                                initialRating: (2 * state.location.avgScore)
                                        .ceilToDouble() /
                                    2,
                                allowHalfRating: true,
                                itemPadding: const EdgeInsets.symmetric(
                                  horizontal: SpaceUnit.quarterBase,
                                ),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemSize: SpaceUnit.quadrupleBase,
                                ignoreGestures: true,
                                onRatingUpdate: print,
                              ),
                              Text(state.location.avgScore.toStringAsFixed(2)),
                              if (state.isLogin && !state.fromMenu)
                                Container(
                                  width: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color.fromRGBO(
                                      184,
                                      197,
                                      181,
                                      1,
                                    ),
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                        169,
                                        179,
                                        146,
                                        1,
                                      ),
                                      width: 3,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog<void>(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('新增評分'),
                                          content: RatingBar.builder(
                                            initialRating: state.score,
                                            allowHalfRating: true,
                                            itemSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                9,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 2,
                                            ),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Color.fromRGBO(
                                                241,
                                                208,
                                                10,
                                                1,
                                              ),
                                            ),
                                            onRatingUpdate:
                                                locationShowCubit.setRate,
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(l10n.cancel),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                locationShowCubit.rate();
                                                Navigator.pop(context);
                                              },
                                              child: Text(l10n.submit),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon:
                                        const Icon(Icons.my_library_add_sharp),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Icon(Icons.location_on),
                                ),
                                Text(state.location.address),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Icon(Icons.phone),
                              ),
                              Text(state.location.phone)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                              left: 40,
                              right: 40,
                            ),
                            child: Text(state.location.introduction ?? ''),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
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
                ],
              ),
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
    final status = context.select(
      (LocationShowCubit cubit) => cubit.state.status,
    );

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
      BlocBuilder<LocationShowCubit, LocationShowState>(
        builder: (context, state) => Column(
          children: [
            for (final post in state.posts!) ...[
              PostCard(post: post),
            ],
          ],
        ),
      );
}
