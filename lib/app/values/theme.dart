import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/values/fonts.dart';
import 'package:pot_g/app/values/palette.dart';

abstract class PotTheme {
  static final theme = ThemeData(
    fontFamily: Pretendard.fontFamily,
    scaffoldBackgroundColor: Palette.white,
    colorSchemeSeed: Palette.primary,
    cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
      primaryColor: Palette.primary,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Palette.white,
      endShape: BeveledRectangleBorder(),
    ),
  );
}
