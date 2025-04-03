import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pot_g/app/values/palette.dart';

enum PotGButtonVariant { emphasized, outlined }

enum PotGButtonSize { small, medium, large }

class PotGButton extends StatefulWidget {
  const PotGButton({
    super.key,
    this.padding,
    this.child,
    this.onPressed,
    this.variant,
    this.size = PotGButtonSize.large,
    this.prefixIcon,
  });

  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final VoidCallback? onPressed;
  final PotGButtonVariant? variant;
  final PotGButtonSize size;
  final Widget? prefixIcon;

  @override
  State<PotGButton> createState() => _PotGButtonState();
}

class _PotGButtonState extends State<PotGButton> {
  bool _pressed = false;
  bool _active = false;
  bool get pressed => _pressed || _active;

  static const _animationDuration = Duration(milliseconds: 50);
  static const _minPressedDuration = Duration(milliseconds: 80);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) {
        if (widget.onPressed == null) return;
        HapticFeedback.lightImpact();
        setState(() {
          _pressed = true;
          _active = true;
        });
        Future.delayed(_minPressedDuration, () {
          if (!mounted) return;
          setState(() => _active = false);
        });
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: _getTextColor(),
          fontWeight: _getFontWeight(),
          fontSize: _getFontSize(),
        ),
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: _animationDuration,
          padding: widget.padding ?? _getPadding(),
          decoration: BoxDecoration(
            borderRadius: _getBorderRadius(),
            border: _getBorder(),
            color: _getBackgroundColor(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.prefixIcon != null) ...[
                widget.prefixIcon!,
                SizedBox(width: _getIconGap()),
              ],
              widget.child!,
            ],
          ),
        ),
      ),
    );
  }

  BorderRadiusGeometry _getBorderRadius() {
    switch (widget.size) {
      case PotGButtonSize.large:
      case PotGButtonSize.medium:
        return BorderRadius.all(Radius.circular(10));
      case PotGButtonSize.small:
        return BorderRadius.all(Radius.circular(5));
    }
  }

  BoxBorder? _getBorder() {
    if (widget.onPressed == null) return null;
    switch (widget.variant) {
      case PotGButtonVariant.outlined:
        return Border.all(color: Palette.primary, width: 1.5);
      case null:
        return Border.all(color: Palette.borderGrey, width: 1.5);
      default:
        return null;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case PotGButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 15);
      case PotGButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 25, vertical: 10);
      case PotGButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 15, vertical: 7);
    }
  }

  Color _getBackgroundColor() {
    if (widget.onPressed == null) return Palette.borderGrey;
    switch (widget.variant) {
      case PotGButtonVariant.emphasized:
        if (pressed) return const Color(0xff346405);
        return Palette.primary;
      case PotGButtonVariant.outlined:
        if (pressed) return Palette.primaryLight;
        return Palette.white;
      default:
        if (pressed) return Palette.lightGrey;
        return Palette.white;
    }
  }

  FontWeight _getFontWeight() {
    switch (widget.size) {
      case PotGButtonSize.large:
        return FontWeight.w700;
      default:
        return FontWeight.w600;
    }
  }

  Color _getTextColor() {
    if (widget.onPressed == null) return Palette.grey;
    switch (widget.variant) {
      case PotGButtonVariant.emphasized:
        return Palette.primaryLight;
      case PotGButtonVariant.outlined:
        return Palette.primary;
      default:
        return Palette.textGrey;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case PotGButtonSize.large:
        return 20;
      default:
        return 18;
    }
  }

  double _getIconGap() {
    switch (widget.size) {
      case PotGButtonSize.large:
        return 8;
      default:
        return 4;
    }
  }
}
