import 'package:flutter/material.dart';

import 'box_properties.dart';

class BoxAndTextStyle {
  static TextStyle textStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22.0,
    color: Colors.white70,
  );

  static BoxAndTextStyle? _instance;
  static BoxAndTextStyle get instance {
    return _instance ??= BoxAndTextStyle._init();
  }

  BoxAndTextStyle._init();

  BoxDecoration getBoxDecoration({
    required BuildContext context,
    required BoxProperties box,
    required bool isRightPosition,
  }) {
    Color color = isRightPosition
        ? box.isTarget
            ? Colors.green.withOpacity(.3)
            : Colors.green
        : box.isTarget
            ? Colors.redAccent.withOpacity(.3)
            : Colors.redAccent;
    return BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      border: Border.all(
        color: color,
      ),
    );
  }
}
