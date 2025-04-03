import 'package:flutter/rendering.dart';

abstract class TextStyles {
  static final title1 = TextStyle(
    fontSize: 28,
    height: 1,
    fontWeight: FontWeight.w700,
  );

  static final title3 = TextStyle(
    fontSize: 20,
    height: 1,
    fontWeight: FontWeight.w700,
  );

  static final title4 = TextStyle(
    fontSize: 18,
    height: 1,
    fontWeight: FontWeight.w600,
  );

  static final description = TextStyle(
    fontSize: 16,
    height: 1,
    fontWeight: FontWeight.w500,
    letterSpacing: -1.5 * 0.01 * 16,
  );

  static final caption = TextStyle(
    fontSize: 14,
    height: 1,
    fontWeight: FontWeight.w400,
  );
}
