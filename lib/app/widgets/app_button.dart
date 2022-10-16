import 'package:flutter/material.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.onPressed,
  });

  final double height;
  final double width;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(184, 197, 181, 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(SpaceUnit.base * 5),
          ),
          border: Border.all(
            color: const Color.fromRGBO(169, 179, 146, 1),
            width: SpaceUnit.quarterBase + SpaceUnit.eighthBase,
          ),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(SpaceUnit.base),
            primary: Colors.black,
            textStyle: AppTextStyle.content,
          ),
          onPressed: onPressed,
          child: Text(title),
        ),
      );
}
