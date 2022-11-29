import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/home/home.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/user/auth/cubit/user_auth_cubit.dart';
import 'package:ones_blog/user/auth/view/user_verify_code_page.dart';
import 'package:ones_blog/user/auth/widgets/form_tab.dart';
import 'package:ones_blog/user/auth/widgets/form_text_field.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/form_validator.dart';
import 'package:ones_blog/utils/size_handler.dart';

class UserAuthPage extends StatelessWidget {
  const UserAuthPage({super.key});

  static Route<UserAuthPage> route() => MaterialPageRoute(
        builder: (context) => const UserAuthPage(),
      );

  @override
  Widget build(BuildContext context) => BlocProvider<UserAuthCubit>.value(
        value: UserAuthCubit(
          userRepository: context.read<UserRepository>(),
        )..init(),
        child: const UserAuthView(),
      );
}

class UserAuthView extends StatefulWidget {
  const UserAuthView({super.key});

  @override
  State createState() => _UserAuthViewState();
}

class _UserAuthViewState extends State<UserAuthView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController,
      _usernameController,
      _passwordController,
      _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final state = context.read<UserAuthCubit>().state;
    _emailController = TextEditingController(
      text: !state.loginTab ? state.unverifiedEmail : null,
    );
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// A method that launches the [UserVerifyCodePage],
  /// and awaits for Navigator.pop.
  Future<void> _navigateUserVerifyCodePage(BuildContext context) async {
    /// Navigator.push returns a Future that completes after calling
    /// Navigator.pop on the UserVerifyCodePage Screen.
    final result = await Navigator.push(
      context,
      UserVerifyCodePage.route(_emailController.value.text),
    );

    /// When a BuildContext is used from a StatefulWidget, the mounted property
    /// must be checked after an asynchronous gap.
    if (!mounted) return;

    if (result?.page == PoppedFromPage.userVerifyCode) {
      await context.read<UserAuthCubit>().resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;
    final userAuthCubit = context.read<UserAuthCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: const MenuView(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            const FixedAppBar(),
          ],
          body: SingleChildScrollView(
            child: Container(
              color: AppColors.primary,
              width: SizeHandler.screenWidth,
              height: SizeHandler.screenHeight * 1.2,
              child: BlocConsumer<UserAuthCubit, UserAuthState>(
                listener: (context, state) {
                  switch (state.status) {
                    case BlocCubitStatus.initial:
                      _formKey.currentState!.reset();
                      _usernameController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                      if (!state.loginTab && state.emailUnverified) {
                        _emailController.text = state.unverifiedEmail!;
                      } else {
                        _emailController.clear();
                      }
                      break;
                    case BlocCubitStatus.loading:
                      EasyLoading.show(
                        status: l10n.submittingMessage,
                      );
                      break;
                    case BlocCubitStatus.success:
                      EasyLoading.showSuccess(
                        state.loginTab
                            ? l10n.loginSuccessMessage
                            : l10n.registerSuccessMessage,
                        duration: state.loginTab
                            ? AppDuration.short
                            : AppDuration.long,
                      );
                      state.loginTab
                          ? Navigator.pushReplacement(
                              context,
                              HomePage.route(),
                            )
                          : _navigateUserVerifyCodePage(context);
                      break;
                    case BlocCubitStatus.failure:
                      EasyLoading.showError(
                        l10n.submittedFailureMessage,
                        duration: AppDuration.short,
                      );
                      break;
                  }
                },
                builder: (context, state) => Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: SpaceUnit.quadrupleBase,
                        ),
                        child: Text(
                          state.loginTab
                              ? l10n.loginPageTitle
                              : l10n.registerPageTitle,
                          style: AppTextStyle.title,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FormTab(
                            color: state.loginTab
                                ? Colors.white
                                : AppColors.primary,
                            onPressed: () =>
                                userAuthCubit.setTab(loginTab: true),
                            text: l10n.login,
                          ),
                          FormTab(
                            color: state.loginTab
                                ? AppColors.primary
                                : Colors.white,
                            onPressed: () =>
                                userAuthCubit.setTab(loginTab: false),
                            text: state.emailUnverified
                                ? l10n.verify
                                : l10n.register,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: SpaceUnit.base * 5,
                        ),
                        height: SpaceUnit.quarterBase,
                        width: SizeHandler.screenWidth,
                        color: Colors.white,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          right: SpaceUnit.base * 6,
                        ),
                        alignment: Alignment.centerRight,
                        height: SpaceUnit.quadrupleBase,
                        width: SizeHandler.screenWidth,
                        child: Text(
                          l10n.requiredText,
                          style: AppTextStyle.alertContent,
                        ),
                      ),
                      FormTextField(
                        label: l10n.email,
                        placeholder: l10n.placeholder(l10n.email.toLowerCase()),
                        keyboardType: TextInputType.emailAddress,
                        readOnly: !state.loginTab && state.emailUnverified,
                        validator: (String? value) => (FormValidator(
                          l10n: l10n,
                          value: value,
                        )
                              ..validateRequired()
                              ..validateEmail())
                            .errorMessage,
                        controller: _emailController,
                      ),
                      if (!state.loginTab && !state.emailUnverified)
                        FormTextField(
                          label: l10n.username,
                          placeholder:
                              l10n.placeholder(l10n.username.toLowerCase()),
                          validator: (String? value) => (FormValidator(
                            l10n: l10n,
                            value: value,
                          )..validateRequired())
                              .errorMessage,
                          controller: _usernameController,
                        ),
                      if (state.loginTab || !state.emailUnverified)
                        FormTextField(
                          label: l10n.password,
                          placeholder:
                              l10n.placeholder(l10n.password.toLowerCase()),
                          obscureText: true,
                          validator: (String? value) => (FormValidator(
                            l10n: l10n,
                            value: value,
                          )
                                ..validateRequired()
                                ..validateMin(6))
                              .errorMessage,
                          controller: _passwordController,
                          marginBottom:
                              SpaceUnit.base * (state.loginTab ? 1 : 5),
                        ),
                      if (!state.loginTab && !state.emailUnverified)
                        FormTextField(
                          label: l10n.confirmPassword,
                          placeholder: l10n.confirmPasswordPlaceholder,
                          obscureText: true,
                          validator: (String? value) => (FormValidator(
                            l10n: l10n,
                            value: value,
                            anotherValue: _passwordController.value.text,
                          )
                                ..validateRequired()
                                ..validateMin(6)
                                ..validateSame(
                                  l10n.confirmPassword,
                                  l10n.password,
                                ))
                              .errorMessage,
                          controller: _confirmPasswordController,
                          marginBottom: SpaceUnit.base,
                        ),
                      // TODO: 忘記密碼功能
                      // if (state.loginTab)
                      //   Container(
                      //     margin: const EdgeInsets.only(
                      //       right: SpaceUnit.base * 6,
                      //     ),
                      //     alignment: Alignment.centerRight,
                      //     width: SizeHandler.screenWidth,
                      //     child: GestureDetector(
                      //       child: Text(l10n.forgetPasswordTitle),
                      //       onTap: () {},
                      //     ),
                      //   ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: SpaceUnit.doubleBase,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppButton(
                              height: SpaceUnit.base * 7,
                              width: SpaceUnit.base * 11,
                              title: (!state.loginTab && state.emailUnverified)
                                  ? l10n.registerAgain
                                  : l10n.cancel,
                              onPressed: () => userAuthCubit.resetForm(
                                registerAgain:
                                    !state.loginTab && state.emailUnverified,
                              ),
                            ),
                            AppButton(
                              height: SpaceUnit.base * 7,
                              width: SpaceUnit.base * 11,
                              title: state.loginTab
                                  ? l10n.login
                                  : state.emailUnverified
                                      ? l10n.verifyEmail
                                      : l10n.register,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (userAuthCubit.state.loginTab ||
                                    !userAuthCubit.state.emailUnverified) {
                                  if (_formKey.currentState!.validate()) {
                                    userAuthCubit.submit(
                                      email: _emailController.value.text,
                                      username: _usernameController.value.text,
                                      password: _passwordController.value.text,
                                    );
                                  }
                                } else {
                                  _navigateUserVerifyCodePage(context);
                                }
                              },
                            ),
                          ],
                        ),
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
