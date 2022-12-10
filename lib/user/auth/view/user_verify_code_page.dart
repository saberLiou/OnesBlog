import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/user/auth/user_auth.dart';
import 'package:ones_blog/user/auth/view/user_reset_password_page.dart';
import 'package:ones_blog/user/auth/widgets/form_text_field.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/form_validator.dart';
import 'package:ones_blog/utils/size_handler.dart';

class UserVerifyCodePage extends StatelessWidget {
  const UserVerifyCodePage({super.key});

  static Route<PoppedFromPageArguments> route({
    required bool registerFlow,
    required String email,
  }) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => UserVerifyCodeCubit(
            registerFlow: registerFlow,
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

class _UserVerifyCodeViewState extends State<UserVerifyCodeView>
    with TickerProviderStateMixin {
  static const int countdownSeconds = 30;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  AnimationController? _countdownController;
  late final Animation<int> _countdownAnimation;

  Future<void> _executeAfterBuild() async => _countdownController!.forward();

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    if (context.read<UserVerifyCodeCubit>().state.registerFlow) {
      _countdownController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: countdownSeconds),
      );
      _countdownAnimation = StepTween(
        begin: countdownSeconds,
        end: 0,
      ).animate(_countdownController!);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _countdownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;
    final userVerifyCodeCubit = context.read<UserVerifyCodeCubit>();
    if (userVerifyCodeCubit.state.registerFlow) {
      _executeAfterBuild();
    }

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
                              status: state.verifyingCode
                                  ? l10n.submittingMessage
                                  : l10n.resendingMessage,
                            );
                            break;
                          case BlocCubitStatus.success:
                            EasyLoading.showSuccess(
                              state.verifyingCode
                                  ? state.registerFlow
                                      ? l10n.verifiedMessage(l10n.appName)
                                      : l10n.codeCheckedSuccessMessage
                                  : l10n.resentSuccessMessage,
                              duration: AppDuration.medium,
                            );
                            if (state.verifyingCode) {
                              Navigator.pushReplacement(
                                context,
                                state.registerFlow
                                    ? UserAuthPage.route()
                                    : UserResetPasswordPage.route(),
                              );
                            } else {
                              _codeController.clear();
                              if (state.registerFlow) {
                                _countdownController!
                                  ..reset()
                                  ..forward();
                              }
                            }
                            break;
                          case BlocCubitStatus.failure:
                            EasyLoading.showError(
                              state.verifyingCode
                                  ? l10n.unverifiedMessage
                                  : l10n.resentFailureMessage,
                              duration: AppDuration.short,
                            );
                            _codeController.clear();
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
                          if (state.registerFlow)
                            Container(
                              margin: const EdgeInsets.only(
                                top: SpaceUnit.doubleBase,
                              ),
                              alignment: Alignment.center,
                              child: Countdown(
                                animation: _countdownAnimation,
                                animatingTitle:
                                    l10n.toResendVerificationCodeTitle,
                                animatedTitle: l10n.resendVerificationCodeTitle,
                                onAnimatedTap:
                                    userVerifyCodeCubit.resendVerificationCode,
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

class Countdown extends AnimatedWidget {
  const Countdown({
    super.key,
    required this.animation,
    required this.animatingTitle,
    required this.animatedTitle,
    required this.onAnimatedTap,
  }) : super(listenable: animation);

  final Animation<int> animation;
  final String Function(String minutes, String seconds) animatingTitle;
  final String animatedTitle;
  final GestureTapCallback onAnimatedTap;

  @override
  Widget build(BuildContext context) {
    final clockTimer = Duration(seconds: animation.value),
        minutes = clockTimer.inMinutes.remainder(60).toString(),
        seconds = clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0');

    return InkWell(
      child: Builder(
        builder: (context) => Text(
          animation.value > 0
              ? animatingTitle(minutes, seconds)
              : animatedTitle,
          style: AppTextStyle.content,
        ),
      ),
      onTap: () {
        if (animation.value == 0) {
          onAnimatedTap();
        }
      },
    );
  }
}
