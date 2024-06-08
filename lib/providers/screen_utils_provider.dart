import 'package:flutter/material.dart';

import '../utils/screen_utils.dart';

class ScreenUtilsProvider extends InheritedWidget {
  final ScreenUtils utils;
  ScreenUtilsProvider({
    super.key,
    required super.child,
  }) : utils = ScreenUtils();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static ScreenUtils of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ScreenUtilsProvider>()!
        .utils;
  }
}
