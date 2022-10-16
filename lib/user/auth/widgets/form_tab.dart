import 'package:flutter/material.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';

class FormTab extends StatelessWidget {
  const FormTab({
    super.key,
    required this.color,
    required this.onPressed,
    required this.text,
  });

  final Color color;
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        width: SpaceUnit.base * 18,
        height: SpaceUnit.base * 5,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(SpaceUnit.tripleBase),
            topLeft: Radius.circular(SpaceUnit.tripleBase),
          ),
          color: color,
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(text, style: AppTextStyle.content),
        ),
      );
}
