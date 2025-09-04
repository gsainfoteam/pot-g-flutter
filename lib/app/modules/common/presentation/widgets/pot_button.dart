import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';

enum PotButtonVariant { emphasized, outlined }

enum PotButtonSize { small, medium, large }

class PotButton extends StatelessWidget {
  const PotButton({
    super.key,
    this.padding,
    this.child,
    this.onPressed,
    this.variant,
    this.size = PotButtonSize.large,
    this.prefixIcon,
  });

  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final VoidCallback? onPressed;
  final PotButtonVariant? variant;
  final PotButtonSize size;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return PotPressable(
      onTap: onPressed,
      builder:
          (pressed) => _Inner(
            pressed: pressed,
            padding: padding,
            prefixIcon: prefixIcon,
            size: size,
            variant: variant,
            onPressed: onPressed,
            child: child,
          ),
    );
  }
}

class _Inner extends StatelessWidget {
  const _Inner({
    required this.pressed,
    required this.padding,
    required this.prefixIcon,
    required this.child,
    required this.size,
    required this.variant,
    required this.onPressed,
  });

  static const _animationDuration = Duration(milliseconds: 50);

  final bool pressed;
  final EdgeInsetsGeometry? padding;
  final Widget? prefixIcon;
  final Widget? child;
  final PotButtonSize size;
  final PotButtonVariant? variant;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: _getTextStyle().copyWith(color: _getTextColor()),
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: _animationDuration,
        padding: padding ?? _getPadding(),
        decoration: BoxDecoration(
          borderRadius: _getBorderRadius(),
          border: _getBorder(),
          color: _getBackgroundColor(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: _getIconGap()),
            ],
            if (child != null) child!,
          ],
        ),
      ),
    );
  }

  BorderRadiusGeometry _getBorderRadius() {
    switch (size) {
      case PotButtonSize.large:
      case PotButtonSize.medium:
        return BorderRadius.all(Radius.circular(10));
      case PotButtonSize.small:
        return BorderRadius.all(Radius.circular(5));
    }
  }

  BoxBorder? _getBorder() {
    if (onPressed == null) return null;
    switch (variant) {
      case PotButtonVariant.outlined:
        return Border.all(color: Palette.primary, width: 1.5);
      case null:
        return Border.all(color: Palette.borderGrey, width: 1.5);
      default:
        return null;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case PotButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 15);
      case PotButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 25, vertical: 10);
      case PotButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 15, vertical: 7);
    }
  }

  Color _getBackgroundColor() {
    if (onPressed == null) return Palette.borderGrey;
    switch (variant) {
      case PotButtonVariant.emphasized:
        if (pressed) return const Color(0xff346405);
        return Palette.primary;
      case PotButtonVariant.outlined:
        if (pressed) return Palette.primaryLight;
        return Palette.white;
      default:
        if (pressed) return Palette.lightGrey;
        return Palette.white;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case PotButtonSize.large:
        return TextStyles.title3;
      default:
        return TextStyles.title4;
    }
  }

  Color _getTextColor() {
    if (onPressed == null) return Palette.grey;
    switch (variant) {
      case PotButtonVariant.emphasized:
        return Palette.primaryLight;
      case PotButtonVariant.outlined:
        return Palette.primary;
      default:
        return Palette.textGrey;
    }
  }

  double _getIconGap() {
    switch (size) {
      case PotButtonSize.large:
        return 8;
      default:
        return 4;
    }
  }
}
