import 'package:flutter/material.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_text_style.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.publishedAt,
    required this.title,
    this.imageUrl,
  });

  final String publishedAt;
  final String title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        // margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          color: AppColors.muted,
          borderRadius: new BorderRadius.all(
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
                      publishedAt,
                      style: AppTextStyle.content,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      title,
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
