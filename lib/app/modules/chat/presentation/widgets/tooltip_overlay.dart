import 'package:flutter/material.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

class TooltipOverlay extends StatelessWidget {
  const TooltipOverlay({
    super.key,
    required this.controller,
    required this.child,
    required this.content,
  });

  final OverlayPortalController controller;
  final Widget child;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: controller,
      overlayChildBuilder: (_, info) {
        final left = info.childPaintTransform.entry(0, 3);
        final top = info.childPaintTransform.entry(1, 3);
        final bottom = info.overlaySize.height - top - info.childSize.height;
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: CirclePainter(
                  holeRect: Rect.fromLTWH(
                    left,
                    top,
                    info.childSize.width,
                    info.childSize.height,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: left + info.childSize.width / 2,
                  vertical: bottom + info.childSize.height + 12,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        constraints: BoxConstraints(maxWidth: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: DefaultTextStyle.merge(
                          style: TextStyles.description,
                          child: content,
                        ),
                      ),
                    ),
                    Positioned(bottom: 0, child: Assets.icons.tooltipTip.svg()),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({required this.holeRect});
  final Rect holeRect;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.black.withValues(alpha: 0.4);
    final path = Path()
      ..addRect(Offset.zero & size)
      ..addOval(holeRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
