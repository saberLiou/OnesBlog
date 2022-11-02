import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ones_blog/app/cubit/menu_cubit.dart';
import 'package:ones_blog/app/view/about_us_page.dart';
import 'package:ones_blog/app/widgets/menu_button.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/home/view/home_page.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/location/ranking/view/location_ranking_page.dart';
import 'package:ones_blog/location/show/location_show.dart';
import 'package:ones_blog/location/store/location_store.dart';
import 'package:ones_blog/post/list/post_list.dart';
import 'package:ones_blog/user/auth/user_auth.dart';
import 'package:ones_blog/user/show/user_show.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/user_login_type.dart';
import 'package:ones_blog/utils/size_handler.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;

    return BlocProvider<MenuCubit>.value(
      value: MenuCubit(
        userRepository: context.read<UserRepository>(),
      )..init(),
      child: SizedBox(
        width: SizeHandler.screenWidth,
        child: Container(
          height: SizeHandler.screenHeight,
          color: AppColors.primary,
          child: BlocConsumer<MenuCubit, MenuState>(
            listener: (context, state) {
              switch (state.status) {
                case BlocCubitStatus.initial:
                  break;
                case BlocCubitStatus.loading:
                  EasyLoading.show(
                    status: state.loginTypeChanged
                        ? l10n.switchingAccountMessage
                        : l10n.loggingOutMessage,
                  );
                  break;
                case BlocCubitStatus.success:
                  EasyLoading.showSuccess(
                    state.loginTypeChanged
                        ? l10n.switchAccountSuccessMessage
                        : l10n.logoutSuccessMessage,
                    duration: AppDuration.short,
                  );
                  Navigator.pushReplacement(
                    context,
                    HomePage.route(),
                  );
                  break;
                case BlocCubitStatus.failure:
                  EasyLoading.showSuccess(
                    state.loginTypeChanged
                        ? l10n.switchAccountFailureMessage
                        : l10n.logoutSuccessMessage,
                    duration: AppDuration.short,
                  );
                  if (!state.loginTypeChanged) {
                    Navigator.pushReplacement(
                      context,
                      HomePage.route(),
                    );
                  }
                  break;
              }
            },
            builder: (context, state) => ListView(
              padding: const EdgeInsets.only(top: SpaceUnit.quadrupleBase),
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: SpaceUnit.doubleBase),
                  child: Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        padding: const EdgeInsets.only(
                          top: SpaceUnit.base,
                          right: SpaceUnit.doubleBase,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.clear,
                          size: SpaceUnit.quadrupleBase,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: SpaceUnit.quarterBase,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MenuButton(
                          title: l10n.leaderboard,
                          imageUrl: 'images/element/rank.png',
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            LocationRankingPage.route(),
                          ),
                        ),
                        MenuButton(
                          title: l10n.community,
                          imageUrl: 'images/element/community.png',
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            PostListPage.route(),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MenuButton(
                          title: l10n.aboutUs,
                          imageUrl: 'images/element/aboutUs.png',
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            AboutUsPage.route(),
                          ),
                        ),
                        if (!state.isLogin)
                          MenuButton(
                            title: l10n.loginOrRegister,
                            imageUrl: 'images/element/login.png',
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              UserAuthPage.route(),
                            ),
                          )
                        else
                          MenuButton(
                            title: l10n.logout,
                            imageUrl: 'images/element/logout.png',
                            onPressed: context.read<MenuCubit>().removeToken,
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (state.isLogin) ...[
                          if (state.userLocation != null)
                            MenuButton(
                              title: l10n.switchToAccount(
                                state.loginType == UserLoginType.user
                                    ? l10n.location
                                    : l10n.user,
                              ),
                              imageUrl:
                                  'images/element/${state.loginType == UserLoginType.user ? 'becomeStore' : 'login'}.png',
                              onPressed:
                                  context.read<MenuCubit>().switchAccount,
                            )
                          else
                            MenuButton(
                              title: l10n.becomeLocation,
                              imageUrl: 'images/element/becomeStore.png',
                              onPressed: () =>
                                  (state.user!.locationAppliedAt == null)
                                      ? Navigator.pushReplacement(
                                          context,
                                          LocationStorePage.route(null),
                                        )
                                      : EasyLoading.showInfo(
                                          l10n.becomeLocationSuccessMessage,
                                          duration: AppDuration.long,
                                        ),
                            ),
                          MenuButton(
                            title: state.loginType == UserLoginType.user
                                ? l10n.userInformation
                                : l10n.locationInformation,
                            imageUrl:
                                'images/element/${state.loginType == UserLoginType.user ? 'login' : 'becomeStore'}.png',
                            onPressed: () =>
                                (state.loginType == UserLoginType.location &&
                                        state.user?.location != null)
                                    ? Navigator.pushReplacement(
                                        context,
                                        LocationShowPage.route(
                                          location: state.user!.location!,
                                          fromMenu: true,
                                        ),
                                      )
                                    : Navigator.pushReplacement(
                                        context,
                                        UserShowPage.route(state.user!),
                                      ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
