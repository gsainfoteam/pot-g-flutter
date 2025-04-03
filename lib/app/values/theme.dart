import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/values/fonts.dart';
import 'package:pot_g/app/values/palette.dart';

abstract class PotGTheme {
  static final theme = ThemeData(
    fontFamily: Pretendard.fontFamily,
    scaffoldBackgroundColor: Palette.white,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Palette.primary,
      selectionColor: Palette.primary.withValues(alpha: 0.4),
      selectionHandleColor: Palette.primary,
    ),
    cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
      primaryColor: Palette.primary,
    ),
  );
}
