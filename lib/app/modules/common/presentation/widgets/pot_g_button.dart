import 'package:flutter/material.dart';
import 'package:pot_g/app/values/palette.dart';

enum PotGButtonVariant { emphasized, outlined }

enum PotGButtonSize { small, medium, large }

class PotGButton extends StatelessWidget {
  const PotGButton({
    super.key,
    this.padding,
    this.child,
    this.onPressed,
    this.variant,
    this.size = PotGButtonSize.large,
  });

  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final VoidCallback? onPressed;
  final PotGButtonVariant? variant;
  final PotGButtonSize size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding ?? _getPadding(),
        decoration: BoxDecoration(
          borderRadius: _getBorderRadius(),
          border: _getBorder(),
          color: _getBackgroundColor(),
        ),
        child: Align(widthFactor: 1, heightFactor: 1, child: child),
      ),
    );
  }

  BorderRadiusGeometry _getBorderRadius() {
    switch (size) {
      case PotGButtonSize.large:
      case PotGButtonSize.medium:
        return BorderRadius.all(Radius.circular(10));
      case PotGButtonSize.small:
        return BorderRadius.all(Radius.circular(5));
    }
  }

  BoxBorder? _getBorder() {
    if (onPressed == null) return null;
    switch (variant) {
      case PotGButtonVariant.outlined:
        return Border.all(color: Palette.primary, width: 1.5);
      case null:
        return Border.all(color: Palette.borerGrey, width: 1.5);
      default:
        return null;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case PotGButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 15);
      case PotGButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 25, vertical: 10);
      case PotGButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 15, vertical: 7);
    }
  }

  Color _getBackgroundColor() {
    if (onPressed == null) return Palette.borerGrey;
    switch (variant) {
      case PotGButtonVariant.emphasized:
        return Palette.primary;
      default:
        return Palette.white;
    }
  }
}
