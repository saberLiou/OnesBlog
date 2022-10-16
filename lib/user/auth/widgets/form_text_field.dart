import 'package:flutter/material.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.validator,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.marginBottom = SpaceUnit.base * 5,
  });

  final String label;
  final String placeholder;
  final String? Function(String?) validator;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final double marginBottom;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(
      top: SpaceUnit.base,
      bottom: marginBottom,
    ),
    width: SpaceUnit.quadrupleBase * 10,
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Container(
          padding: const EdgeInsets.only(
            bottom: SpaceUnit.quadrupleBase * 2,
          ),
          child: RichText(
            text: TextSpan(
              style: AppTextStyle.title,
              children: [
                const TextSpan(
                  text: '*',
                  style: TextStyle(
                    fontSize: SpaceUnit.base * 3.5,
                    color: Colors.red,
                  ),
                ),
                TextSpan(text: label),
              ],
            ),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: placeholder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            SpaceUnit.base * 2.5,
          ),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
