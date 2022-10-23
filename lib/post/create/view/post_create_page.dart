import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/location/search/view/location_search_page.dart';
import 'package:ones_blog/post/create/cubit/post_create_cubit.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';
import 'package:ones_blog/utils/form_validator.dart';
import 'package:ones_blog/utils/size_handler.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({super.key});

  static Route<PoppedFromPageArguments> route() => MaterialPageRoute(
        builder: (context) => BlocProvider<PostCreateCubit>.value(
          value: PostCreateCubit(
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
          ),
          child: const PostCreateView(),
        ),
      );

  @override
  Widget build(BuildContext context) => const PostCreateView();
}

class PostCreateView extends StatefulWidget {
  const PostCreateView({super.key});

  @override
  State createState() => _PostCreateViewState();
}

class _PostCreateViewState extends State<PostCreateView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  /// A method that launches the [LocationSearchPage],
  /// and awaits for Navigator.pop to reset register tab.
  Future<void> _navigateLocationSearchPage(BuildContext context) async {
    /// Navigator.push returns a Future that completes after calling
    /// Navigator.pop on the LocationSearchPage Screen.
    final postCreateCubit = context.read<PostCreateCubit>();
    final result = await Navigator.push(
      context,
      LocationSearchPage.route(postCreateCubit.state.locationCategory),
    );

    /// When a BuildContext is used from a StatefulWidget, the mounted property
    /// must be checked after an asynchronous gap.
    if (!mounted) return;

    if (result?.page == PoppedFromPage.selectLocation &&
        result!.arguments != null) {
      postCreateCubit.setLocationName(
        locationId: result.arguments!['locationId'] as int,
        locationName: result.arguments!['locationName'] as String,
      );
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
    final postCreateCubit = context.read<PostCreateCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: const MenuView(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            const FixedAppBar(),
          ],
          body: BlocListener<PostCreateCubit, PostCreateState>(
            listener: (context, state) {
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
                  Navigator.pop(
                    context,
                    PoppedFromPageArguments(
                      page: PoppedFromPage.addPost,
                      arguments: {
                        'locationCategory': state.locationCategory,
                      },
                    ),
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
            child: SingleChildScrollView(
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
                          Container(
                            width: 300,
                            height: SpaceUnit.base * 6,
                            margin: const EdgeInsets.symmetric(
                              vertical: SpaceUnit.doubleBase,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(SpaceUnit.base),
                              ),
                            ),
                            child: DropdownButtonFormField2(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              value: LocationCategory.restaurants,
                              onChanged: (value) =>
                                  postCreateCubit.selectLocationCategory(
                                value! as LocationCategory,
                              ),
                              items: LocationCategory.values
                                  .map(
                                    (category) =>
                                        DropdownMenuItem<LocationCategory>(
                                      value: category,
                                      child: Center(
                                        child: Text(
                                          category.translate(l10n),
                                          style: AppTextStyle.content,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
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
                                  margin:
                                      EdgeInsets.only(top: 20.0, bottom: 10.0),
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
                                            BorderRadius.circular(20.0),
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
                                  height: 2.0,
                                  width: 280,
                                  color: Color.fromRGBO(222, 215, 209, 1),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 20.0, bottom: 10.0),
                                  width: 300,
                                  height: 40,
                                  child: TextButton(
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
                                          postCreateCubit.state.locationName,
                                          style: AppTextStyle.content,
                                        ),
                                      ],
                                    ),
                                    onPressed: () =>
                                        _navigateLocationSearchPage(context),
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  width: 280,
                                  color: AppColors.primary,
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 20.0, bottom: 10.0),
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
                                            BorderRadius.circular(20.0),
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
                                  if (postCreateCubit.state.locationId ==
                                      null) {
                                    EasyLoading.showInfo(
                                      l10n.emptyLocationMessage,
                                      duration: AppDuration.short,
                                    );
                                  } else if (_formKey.currentState!
                                      .validate()) {
                                    postCreateCubit.submit(
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
            ),
          ),
        ),
      ),
    );
  }
}
