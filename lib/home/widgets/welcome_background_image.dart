import 'package:flutter/material.dart';

class WelcomeBackgroundImage extends StatelessWidget {
  const WelcomeBackgroundImage({
    super.key,
    required this.top,
    required this.left,
    required this.imageUrl,
    required this.imageWidth,
  });

  final double? top;
  final double? left;
  final String imageUrl;
  final double? imageWidth;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Image(
        image: AssetImage(imageUrl),
        width: imageWidth,
      ),
    );
  }
}
