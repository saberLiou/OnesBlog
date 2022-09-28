import 'package:flutter/material.dart';
import 'package:ones_blog/utils/app_text_style.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.route,
  });

  final String title;
  final String imageUrl;
  final Route route;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(top: 32),
      width: 120,
      height: 80,
      child: TextButton(
        child: Column(
          children: [
            Image(
              image: AssetImage(imageUrl),
              width: 40,
            ),
            Text(
              title,
              style: AppTextStyle.title,
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).push(route);
        },
      ),
    );
  }
}
