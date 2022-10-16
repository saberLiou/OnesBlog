import 'package:flutter/material.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onPressed,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpaceUnit.base),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(top: SpaceUnit.quadrupleBase),
      width: 160,
      height: SpaceUnit.base * 10,
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          children: [
            Image(
              image: AssetImage(imageUrl),
              width: SpaceUnit.base * 5,
            ),
            Text(
              title,
              style: AppTextStyle.content,
            ),
          ],
        ),
      ),
    );
  }
}
