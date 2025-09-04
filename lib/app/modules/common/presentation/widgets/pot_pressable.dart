import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PotPressable extends StatefulWidget {
  const PotPressable({
    super.key,
    required this.onTap,
    this.child,
    this.builder,
    this.hitTestBehavior,
  }) : assert(
         child != null || builder != null,
         'Either child or builder must be provided',
       ),
       assert(
         child == null || builder == null,
         'Only one of child or builder must be provided',
       );

  final VoidCallback? onTap;
  final Widget? child;
  final Widget Function(bool pressed)? builder;
  final HitTestBehavior? hitTestBehavior;

  @override
  State<PotPressable> createState() => _PotPressableState();
}

class _PotPressableState extends State<PotPressable> {
  bool _pressed = false;
  bool _active = false;
  bool get pressed => _pressed || _active;

  static const _minPressedDuration = Duration(milliseconds: 80);
  static const _animationDuration = Duration(milliseconds: 50);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.hitTestBehavior,
      onTap: widget.onTap,
      onTapDown: (_) {
        if (widget.onTap == null) return;
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
      child:
          widget.builder?.call(pressed) ??
          AnimatedOpacity(
            opacity: pressed ? 0.5 : 1.0,
            duration: _animationDuration,
            child: widget.child!,
          ),
    );
  }
}
