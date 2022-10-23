import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ones_blog/app/cubit/menu_cubit.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/user/auth/user_auth.dart';
import 'package:ones_blog/user/auth/widgets/form_text_field.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/form_validator.dart';
import 'package:ones_blog/utils/size_handler.dart';

class UserVerifyCodePage extends StatelessWidget {
  const UserVerifyCodePage({super.key});

  static Route<PoppedFromPageArguments> route(String email) => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => UserVerifyCodeCubit(
            userRepository: context.read<UserRepository>(),
            email: email,
          ),
          child: const UserVerifyCodePage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const UserVerifyCodeView();
}

class UserVerifyCodeView extends StatefulWidget {
  const UserVerifyCodeView({super.key});

  @override
  State createState() => _UserVerifyCodeViewState();
}

class _UserVerifyCodeViewState extends State<UserVerifyCodeView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;
    final userVerifyCodeCubit = context.read<UserVerifyCodeCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            FixedAppBar(
              homeLeadingIcon: false,
              openMenuIcon: null,
              arguments: PoppedFromPageArguments(
                page: PoppedFromPage.userVerifyCode,
              ),
            ),
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
                      label: l10n.verifyCode,
                      placeholder:
                          l10n.placeholder(l10n.verifyCode.toLowerCase()),
                      validator: (String? value) => (FormValidator(
                        l10n: l10n,
                        value: value,
                      )..validateRequired())
                          .errorMessage,
                      controller: _codeController,
                      marginBottom: SpaceUnit.tripleBase,
                    ),
                    BlocConsumer<UserVerifyCodeCubit, UserVerifyCodeState>(
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
                              l10n.verifiedMessage(l10n.appName),
                              duration: AppDuration.medium,
                            );
                            Navigator.pushReplacement(
                              context,
                              UserAuthPage.route(),
                            );
                            break;
                          case BlocCubitStatus.failure:
                            EasyLoading.showError(
                              l10n.unverifiedMessage,
                              duration: AppDuration.short,
                            );
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
                                userVerifyCodeCubit.submit(
                                  _codeController.value.text,
                                );
                              }
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: SpaceUnit.doubleBase,
                            ),
                            child: GestureDetector(
                              child: Text(l10n.resendVerifyCodeTitle),
                              onTap: () {
                                // TODO: 重寄驗證信功能
                              },
                            ),
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
