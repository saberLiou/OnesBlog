import 'package:flutter/material.dart';
import 'package:ones_blog/app/widgets/menu_button.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/post/list/post_list.dart';
import 'package:ones_blog/utils/app_colors.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.primary,
        child: ListView(
          padding: EdgeInsets.only(top: 30),
          children: [
            Row(
              children: [
                Spacer(),
                IconButton(
                  padding: EdgeInsets.only(top: 10, right: 20),
                  onPressed: () => Navigator.of(context).pop(context),
                  icon: Icon(
                    Icons.clear,
                    size: 40,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 2.0,
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
                      route: PostListPage.route(),
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
                    // TODO: 成為店家, 登出
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
