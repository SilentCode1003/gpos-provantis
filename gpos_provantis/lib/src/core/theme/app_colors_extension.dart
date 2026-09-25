import 'package:flutter/material.dart';

import 'app_colors.dart';

extension AppColorsContext on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
