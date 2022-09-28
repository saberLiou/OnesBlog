import 'package:flutter/material.dart';

class OpenMenuButton extends StatelessWidget {
  const OpenMenuButton({super.key});

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => IconButton(
          icon: Image.asset('images/element/menu.png'),
          iconSize: 70,
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      );
}
