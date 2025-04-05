import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';

enum PotButtonVariant { emphasized, outlined }

enum PotButtonSize { small, medium, large }

class PotButton extends StatefulWidget {
  const PotButton({
    super.key,
    this.padding,
    this.child,
    this.onPressed,
    this.variant = PotButtonVariant.emphasized,
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
  State<PotButton> createState() => _PotButtonState();
}

class _PotButtonState extends State<PotButton> {
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
        style: _getTextStyle().copyWith(color: _getTextColor()),
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
      case PotButtonSize.large:
      case PotButtonSize.medium:
        return BorderRadius.all(Radius.circular(10));
      case PotButtonSize.small:
        return BorderRadius.all(Radius.circular(5));
    }
  }

  BoxBorder? _getBorder() {
    if (widget.onPressed == null) return null;
    switch (widget.variant) {
      case PotButtonVariant.outlined:
        return Border.all(color: Palette.primary, width: 1.5);
      case null:
        return Border.all(color: Palette.borderGrey, width: 1.5);
      default:
        return null;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case PotButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 15);
      case PotButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 25, vertical: 10);
      case PotButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 15, vertical: 7);
    }
  }

  Color _getBackgroundColor() {
    if (widget.onPressed == null) return Palette.borderGrey;
    switch (widget.variant) {
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
    switch (widget.size) {
      case PotButtonSize.large:
        return TextStyles.title3;
      default:
        return TextStyles.title4;
    }
  }

  Color _getTextColor() {
    if (widget.onPressed == null) return Palette.grey;
    switch (widget.variant) {
      case PotButtonVariant.emphasized:
        return Palette.primaryLight;
      case PotButtonVariant.outlined:
        return Palette.primary;
      default:
        return Palette.textGrey;
    }
  }

  double _getIconGap() {
    switch (widget.size) {
      case PotButtonSize.large:
        return 8;
      default:
        return 4;
    }
  }
}
