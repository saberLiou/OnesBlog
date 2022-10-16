import 'package:flutter/material.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';

extension AppTextStyle on TextStyle {
  static const title = TextStyle(
    fontSize: SpaceUnit.tripleBase,
    color: Colors.black,
  );

  static const content = TextStyle(
    fontSize: SpaceUnit.doubleBase,
    color: Colors.black,
  );

  static const alertContent = TextStyle(
    fontSize: SpaceUnit.doubleBase,
    color: Colors.red,
  );
}
