import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/user/auth/cubit/user_forget_password_cubit.dart';
import 'package:ones_blog/user/auth/user_auth.dart';
import 'package:ones_blog/user/auth/widgets/form_text_field.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/form_validator.dart';
import 'package:ones_blog/utils/size_handler.dart';

class UserForgetPasswordPage extends StatelessWidget {
  const UserForgetPasswordPage({super.key});

  static Route<UserForgetPasswordPage> route() => MaterialPageRoute(
        builder: (context) => const UserForgetPasswordPage(),
      );

  @override
  Widget build(BuildContext context) =>
      BlocProvider<UserForgetPasswordCubit>.value(
        value: UserForgetPasswordCubit(
          userRepository: context.read<UserRepository>(),
        ),
        child: const UserForgetPasswordView(),
      );
}

class UserForgetPasswordView extends StatefulWidget {
  const UserForgetPasswordView({super.key});

  @override
  State createState() => _UserForgetPasswordViewState();
}

class _UserForgetPasswordViewState extends State<UserForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;
    final userForgetPasswordCubit = context.read<UserForgetPasswordCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            const FixedAppBar(homeLeadingIcon: false, openMenuIcon: null),
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
                      label: l10n.email,
                      placeholder: l10n.placeholder(l10n.email.toLowerCase()),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) => (FormValidator(
                        l10n: l10n,
                        value: value,
                      )
                            ..validateRequired()
                            ..validateEmail())
                          .errorMessage,
                      controller: _emailController,
                      marginBottom: SpaceUnit.tripleBase,
                    ),
                    BlocConsumer<UserForgetPasswordCubit,
                        UserForgetPasswordState>(
                      listener: (context, state) {
                        switch (state.status) {
                          case BlocCubitStatus.initial:
                            break;
                          case BlocCubitStatus.loading:
                            EasyLoading.show(status: l10n.submittingMessage);
                            break;
                          case BlocCubitStatus.success:
                            EasyLoading.showSuccess(
                              l10n.emailSentSuccessMessage(l10n.submit),
                              duration: AppDuration.medium,
                            );
                            Navigator.push(
                              context,
                              UserVerifyCodePage.route(
                                registerFlow: false,
                                email: _emailController.value.text,
                              ),
                            );
                            break;
                          case BlocCubitStatus.failure:
                            EasyLoading.showError(
                              l10n.submittedFailureMessage,
                              duration: AppDuration.short,
                            );
                            _emailController.clear();
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
                                userForgetPasswordCubit.submit(
                                  _emailController.value.text,
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
