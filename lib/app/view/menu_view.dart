import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ones_blog/app/cubit/menu_cubit.dart';
import 'package:ones_blog/app/widgets/menu_button.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/home/view/home_page.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/post/list/post_list.dart';
import 'package:ones_blog/user/auth/user_auth.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/size_handler.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => MenuCubit(
        userRepository: context.read<UserRepository>(),
      )..getToken(),
      child: SizedBox(
        width: SizeHandler.screenWidth,
        child: Container(
          height: SizeHandler.screenHeight,
          color: AppColors.primary,
          child: ListView(
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
                      // TODO: 排行榜
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
                      // TODO: 關於我們, 個人資訊
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // TODO: 成為店家
                      BlocConsumer<MenuCubit, MenuState>(
                        listener: (context, state) {
                          switch (state.status) {
                            case BlocCubitStatus.initial:
                              break;
                            case BlocCubitStatus.loading:
                              EasyLoading.show(
                                status: l10n.loggingOutMessage,
                              );
                              break;
                            case BlocCubitStatus.success:
                            case BlocCubitStatus.failure:
                              EasyLoading.showSuccess(
                                l10n.logoutSuccessMessage,
                                duration: AppDuration.short,
                              );
                              Navigator.pushReplacement(
                                context,
                                HomePage.route(),
                              );
                              break;
                          }
                        },
                        builder: (context, state) => state.token == null
                            ? MenuButton(
                                title: l10n.loginOrRegister,
                                imageUrl: 'images/element/login.png',
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  UserAuthPage.route(),
                                ),
                              )
                            : MenuButton(
                                title: l10n.logout,
                                imageUrl: 'images/element/logout.png',
                                onPressed: () =>
                                    context.read<MenuCubit>().removeToken(),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
