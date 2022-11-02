import 'package:flutter/material.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/post/show/post_show.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_text_style.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.imageUrl,
  });

  final Post post;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        PostShowPage.route(post),
      ),
      child: Container(
        // margin: EdgeInsets.only(top: 10.0),
        decoration: const BoxDecoration(
          color: AppColors.muted,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        width: 335,
        height: 85,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      post.user!.name,
                      style: AppTextStyle.content,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      post.title,
                      style: AppTextStyle.content,
                    ),
                ),
              ],
            ),
            Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image(
                image: AssetImage(imageUrl ?? 'images/element/test.jpeg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
