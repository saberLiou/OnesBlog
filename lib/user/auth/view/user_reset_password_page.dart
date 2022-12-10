import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/user/auth/cubit/user_reset_password_cubit.dart';
import 'package:ones_blog/user/auth/user_auth.dart';
import 'package:ones_blog/user/auth/widgets/form_text_field.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/form_validator.dart';
import 'package:ones_blog/utils/size_handler.dart';

class UserResetPasswordPage extends StatelessWidget {
  const UserResetPasswordPage({super.key});

  static Route<UserResetPasswordPage> route() => MaterialPageRoute(
        builder: (context) => const UserResetPasswordPage(),
      );

  @override
  Widget build(BuildContext context) =>
      BlocProvider<UserResetPasswordCubit>.value(
        value: UserResetPasswordCubit(
          userRepository: context.read<UserRepository>(),
        ),
        child: const UserResetPasswordView(),
      );
}

class UserResetPasswordView extends StatefulWidget {
  const UserResetPasswordView({super.key});

  @override
  State createState() => _UserResetPasswordViewState();
}

class _UserResetPasswordViewState extends State<UserResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController,
      _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;
    final userResetPasswordCubit = context.read<UserResetPasswordCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            const FixedAppBar(homeLeadingIcon: null, openMenuIcon: null),
          ],
          body: SingleChildScrollView(
            child: Container(
              color: AppColors.primary,
              width: SizeHandler.screenWidth,
              height: SizeHandler.screenHeight,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    ),
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
                    ),
                    BlocConsumer<UserResetPasswordCubit,
                        UserResetPasswordState>(
                      listener: (context, state) {
                        switch (state.status) {
                          case BlocCubitStatus.initial:
                            break;
                          case BlocCubitStatus.loading:
                            EasyLoading.show(status: l10n.submittingMessage);
                            break;
                          case BlocCubitStatus.success:
                            EasyLoading.showSuccess(
                              l10n.resetPasswordSuccessMessage,
                              duration: AppDuration.medium,
                            );
                            Navigator.pushReplacement(
                              context,
                              UserAuthPage.route(),
                            );
                            break;
                          case BlocCubitStatus.failure:
                            EasyLoading.showError(
                              l10n.submittedFailureMessage,
                              duration: AppDuration.short,
                            );
                            _passwordController.clear();
                            _confirmPasswordController.clear();
                            break;
                        }
                      },
                      builder: (context, state) => Column(
                        children: [
                          AppButton(
                            height: SpaceUnit.base * 7,
                            width: SpaceUnit.base * 11,
                            title: l10n.submit,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                userResetPasswordCubit.submit(
                                  _passwordController.value.text,
                                );
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
    );
  }
}
