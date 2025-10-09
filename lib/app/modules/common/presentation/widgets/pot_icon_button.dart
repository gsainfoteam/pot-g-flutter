import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PotIconButton extends StatelessWidget {
  const PotIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = const Size(24, 24),
    this.padding = const EdgeInsets.all(6),
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final Size size;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onPressed == null) return;
        HapticFeedback.lightImpact();
        onPressed!();
      },
      child: SizedBox.fromSize(
        size: padding.inflateSize(size),
        child: Center(child: SizedBox.fromSize(size: size, child: icon)),
      ),
    );
  }
}
