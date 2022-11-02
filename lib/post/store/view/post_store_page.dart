import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/location/search/view/location_search_page.dart';
import 'package:ones_blog/location/widgets/location_category_select.dart';
import 'package:ones_blog/post/list/view/post_list_page.dart';
import 'package:ones_blog/post/store/cubit/post_store_cubit.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';
import 'package:ones_blog/utils/form_validator.dart';
import 'package:ones_blog/utils/size_handler.dart';

class PostStorePage extends StatelessWidget {
  const PostStorePage({super.key});

  static Route<PoppedFromPageArguments> route(Post? post) => MaterialPageRoute(
        builder: (context) => BlocProvider<PostStoreCubit>.value(
          value: PostStoreCubit(
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
            post: post,
          )..init(),
          child: const PostStorePage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const PostStoreView();
}

class PostStoreView extends StatefulWidget {
  const PostStoreView({super.key});

  @override
  State createState() => _PostStoreViewState();
}

class _PostStoreViewState extends State<PostStoreView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController, _contentController;

  /// A method that launches the [LocationSearchPage],
  /// and awaits for Navigator.pop.
  Future<void> _navigateLocationSearchPage(BuildContext context) async {
    /// Navigator.push returns a Future that completes after calling
    /// Navigator.pop on the LocationSearchPage Screen.
    final postStoreCubit = context.read<PostStoreCubit>();
    final result = await Navigator.push(
      context,
      LocationSearchPage.route(postStoreCubit.state.locationCategory),
    );

    /// When a BuildContext is used from a StatefulWidget, the mounted property
    /// must be checked after an asynchronous gap.
    if (!mounted) return;

    if (result?.page == PoppedFromPage.selectLocation &&
        result!.arguments != null) {
      postStoreCubit.setLocationName(
        locationId: result.arguments!['locationId'] as int,
        locationName: result.arguments!['locationName'] as String,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final post = context.read<PostStoreCubit>().state.post;
    if (post != null) {
      _titleController = TextEditingController(text: post.title);
      _contentController = TextEditingController(text: post.content);
    } else {
      _titleController = TextEditingController();
      _contentController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;
    final postStoreCubit = context.read<PostStoreCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: const MenuView(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            const FixedAppBar(),
          ],
          body: BlocConsumer<PostStoreCubit, PostStoreState>(
            listener: (context, state) {
              // print('state:' + state.title);
              // print('_titleController:' + _titleController.text);
              switch (state.status) {
                case BlocCubitStatus.initial:
                  break;
                case BlocCubitStatus.loading:
                  EasyLoading.show(
                    status: l10n.submittingMessage,
                  );
                  break;
                case BlocCubitStatus.success:
                  EasyLoading.showSuccess(
                    l10n.submittedSuccessMessage,
                    duration: AppDuration.short,
                  );
                  state.post == null
                      ? Navigator.pop(
                          context,
                          PoppedFromPageArguments(
                            page: PoppedFromPage.addPost,
                            arguments: {
                              'locationCategory': state.locationCategory,
                            },
                          ),
                        )
                      : Navigator.pushReplacement(
                          context,
                          PostListPage.route(),
                        );
                  break;
                case BlocCubitStatus.failure:
                  EasyLoading.showError(
                    l10n.submittedFailureMessage,
                    duration: AppDuration.short,
                  );
                  break;
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: AppColors.primary,
                      height: SizeHandler.screenHeight + 200,
                      width: SizeHandler.screenWidth,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            LocationCategorySelect(
                              onChanged: (state.post == null)
                                  ? (value) =>
                                      postStoreCubit.selectLocationCategory(
                                        value! as LocationCategory,
                                      )
                                  : null,
                              l10n: l10n,
                              value: LocationCategory.getById(
                                state.post?.location?.categoryId,
                              ),
                            ),
                            Container(
                              width: 300,
                              height: 650,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(SpaceUnit.base),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 10,
                                    ),
                                    width: 300,
                                    height: 40,
                                    child: TextFormField(
                                      controller: _titleController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: l10n.title,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      validator: (String? value) =>
                                          (FormValidator(
                                        l10n: l10n,
                                        value: value,
                                      )..validateRequired())
                                              .errorMessage,
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: 280,
                                    color: Color.fromRGBO(222, 215, 209, 1),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 20.0, bottom: 10.0),
                                    width: 300,
                                    height: 40,
                                    child: TextButton(
                                      onPressed: (state.post == null)
                                          ? () => _navigateLocationSearchPage(
                                              context)
                                          : null,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: SpaceUnit.base,
                                            ),
                                            child: const Icon(
                                              FontAwesomeIcons.locationDot,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          Text(
                                            state.locationName,
                                            style: AppTextStyle.content,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: 280,
                                    color: AppColors.primary,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 10,
                                    ),
                                    width: 300,
                                    height: 350,
                                    child: TextFormField(
                                      controller: _contentController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: l10n.content,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 280,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromRGBO(241, 208, 10, 1),
                                        width: 2,
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Icon(
                                        FontAwesomeIcons.photoFilm,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AppButton(
                                  height: SpaceUnit.base * 7,
                                  width: SpaceUnit.base * 11,
                                  title: l10n.cancel,
                                  onPressed: () => Navigator.pop(context),
                                ),
                                AppButton(
                                  height: SpaceUnit.base * 7,
                                  width: SpaceUnit.base * 11,
                                  title: l10n.submit,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (postStoreCubit.state.locationId ==
                                        null) {
                                      EasyLoading.showInfo(
                                        l10n.emptyLocationMessage,
                                        duration: AppDuration.short,
                                      );
                                    } else if (_formKey.currentState!
                                        .validate()) {
                                      postStoreCubit.submit(
                                        title: _titleController.value.text,
                                        content: _contentController.value.text,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
