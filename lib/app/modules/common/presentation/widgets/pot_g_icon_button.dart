import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PotGIconButton extends StatelessWidget {
  const PotGIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = const Size(24, 24),
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed == null) return;
        HapticFeedback.lightImpact();
        onPressed!();
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(child: SizedBox.fromSize(size: size, child: icon)),
      ),
    );
  }
}
