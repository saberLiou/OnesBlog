import 'package:flutter/material.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  static Route<AboutUsPage> route() => MaterialPageRoute(
        builder: (context) => const AboutUsPage(),
      );

  @override
  Widget build(BuildContext context) => const AboutUsView();
}

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          endDrawer: const MenuView(),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              const FixedAppBar(),
            ],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: AppColors.primary,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              child: Image(
                                image: AssetImage('images/text/titleWord.png'),
                                width: 160,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Image(
                                image: AssetImage('images/text/onesBlog.png'),
                                width: SpaceUnit.base * 20,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 40, right: 20, left: 20, bottom: 80),
                          child: Text(
                            '''
今天想去哪呢？
玩食部落提供了綠色的餐廳、景點、民宿
讓我們一起去綠色旅遊
跟我們一起保護地球吧！\n
想記錄自己到每個地方的想法嗎？
歡迎到玩食部落分享貼文，讓更多人看到你的生活分享！\n
吃美食、玩景點、住好房
玩食部落歡迎你''',
                            style: AppTextStyle.content,
                          ),
                        ),
                        // TODO: Add Hypertext
                        const Text('''
聯絡我們：onesblog1026@gmail.com\n
關注我們：
Instagram -> ones.blog_1026
Facebook -> 玩食部落 One’s Blog
                        '''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
