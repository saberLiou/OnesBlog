import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/user/update/user_update.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/form_validator.dart';
import 'package:ones_blog/utils/size_handler.dart';

class UserUpdatePage extends StatelessWidget {
  const UserUpdatePage({super.key});

  static Route<PoppedFromPageArguments> route() => MaterialPageRoute(
        builder: (context) => const UserUpdatePage(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserUpdateCubit(
        userRepository: context.read<UserRepository>(),
      ),
      child: const UserUpdateView(),
    );
  }
}

class UserUpdateView extends StatefulWidget {
  const UserUpdateView({super.key});

  @override
  State createState() => _UserUpdateViewState();
}

class _UserUpdateViewState extends State<UserUpdateView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController,
      _passwordController,
      _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserUpdateCubit>().state.user;
    _usernameController = TextEditingController(text: user.name);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;
    final userUpdateCubit = context.read<UserUpdateCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: const MenuView(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            FixedAppBar(
              homeLeadingIcon: false,
              arguments: PoppedFromPageArguments(
                page: PoppedFromPage.updateUser,
              ),
            ),
          ],
          body: BlocConsumer<UserUpdateCubit, UserUpdateState>(
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
                      page: PoppedFromPage.updateUser,
                      arguments: {
                        'submitted': true,
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
            builder: (context, state) => SingleChildScrollView(
              child: Container(
                color: AppColors.primary,
                height: SizeHandler.screenHeight,
                width: SizeHandler.screenWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset('images/element/member.png'),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 400,
                        margin: const EdgeInsets.symmetric(
                          vertical: SpaceUnit.doubleBase,
                        ),
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
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: l10n.username,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (String? value) => (FormValidator(
                                  l10n: l10n,
                                  value: value,
                                )..validateRequired())
                                    .errorMessage,
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
                              height: 40,
                              child: TextFormField(
                                style: TextStyle(color: AppColors.muted),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: l10n.email,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                initialValue: userUpdateCubit.state.user.email,
                                readOnly: true,
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
                              height: 40,
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: l10n.newPassword,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                                validator: (String? value) => (FormValidator(
                                  l10n: l10n,
                                  value: value,
                                )..validateMin(6))
                                    .errorMessage,
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
                              height: 40,
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: l10n.confirmNewPassword,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                                validator: (String? value) => (FormValidator(
                                  l10n: l10n,
                                  value: value,
                                  anotherValue: _passwordController.value.text,
                                )
                                      ..validateMin(6)
                                      ..validateSame(
                                        l10n.confirmNewPassword,
                                        l10n.newPassword,
                                      ))
                                    .errorMessage,
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 280,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppButton(
                            height: SpaceUnit.base * 7,
                            width: SpaceUnit.base * 11,
                            title: l10n.cancel,
                            onPressed: () => Navigator.pop(
                              context,
                              PoppedFromPageArguments(
                                page: PoppedFromPage.updateUser,
                              ),
                            ),
                          ),
                          AppButton(
                            height: SpaceUnit.base * 7,
                            width: SpaceUnit.base * 11,
                            title: l10n.submit,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                userUpdateCubit.submit(
                                  username: _usernameController.value.text,
                                  password: _passwordController.value.text,
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
            ),
          ),
        ),
      ),
    );
  }
}
