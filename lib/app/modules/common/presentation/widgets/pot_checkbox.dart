import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/values/palette.dart';

class PotCheckbox extends StatelessWidget {
  const PotCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final bool value;
  final void Function(bool? value) onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PotPressable(
      onTap: enabled ? () => onChanged(!value) : null,
      builder:
          (pressed) => Padding(
            padding: const EdgeInsets.all(6),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  tween: Tween(begin: 0.0, end: value ? 1.0 : 0.0),
                  builder:
                      (context, animationValue, child) => CustomPaint(
                        painter: _CheckboxPainter(
                          value: value,
                          enabled: enabled,
                          pressed: pressed,
                          animationValue: animationValue,
                        ),
                      ),
                ),
              ),
            ),
          ),
    );
  }
}

class _CheckboxPainter extends CustomPainter {
  const _CheckboxPainter({
    required this.value,
    required this.enabled,
    required this.pressed,
    required this.animationValue,
  });

  final bool value;
  final bool enabled;
  final bool pressed;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final borderWidth = 1.5;

    // 배경 그리기 (애니메이션 적용)
    if (enabled) {
      // 활성 상태: 애니메이션된 배경색
      final animatedColor =
          Color.lerp(Palette.white, Palette.primary, animationValue)!;

      final backgroundPaint =
          Paint()
            ..color = animatedColor
            ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: size.width,
            height: size.height,
          ),
          const Radius.circular(4),
        ),
        backgroundPaint,
      );
    } else {
      // 비활성: 회색 배경
      final backgroundPaint =
          Paint()
            ..color = Palette.borderGrey
            ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: size.width,
            height: size.height,
          ),
          const Radius.circular(4),
        ),
        backgroundPaint,
      );
    }

    // 테두리 그리기 (애니메이션 적용)
    if (enabled) {
      // 활성 상태: 애니메이션된 테두리 투명도
      final borderOpacity = (1.0 - animationValue).clamp(0.0, 1.0);
      final borderColor = Palette.borderGrey2.withValues(alpha: borderOpacity);

      final borderPaint =
          Paint()
            ..color = borderColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = borderWidth;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: size.width,
            height: size.height,
          ),
          const Radius.circular(4),
        ),
        borderPaint,
      );
    } else {
      // 비활성: 회색 테두리
      final borderPaint =
          Paint()
            ..color = Palette.grey
            ..style = PaintingStyle.stroke
            ..strokeWidth = borderWidth;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: size.width,
            height: size.height,
          ),
          const Radius.circular(4),
        ),
        borderPaint,
      );
    }

    // 체크마크 또는 X선 그리기 (애니메이션 적용)
    if (enabled && animationValue > 0) {
      // 애니메이션된 체크마크
      _drawAnimatedCheckmark(canvas, center, size);
    } else if (!enabled) {
      // 회색 X선
      _drawXLine(canvas, center, size);
    }
  }

  void _drawAnimatedCheckmark(Canvas canvas, Offset center, Size size) {
    final paint =
        Paint()
          ..color = Palette.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final checkSize = size.width * 0.7;
    final animatedCheckSize = checkSize * animationValue;

    // 애니메이션된 체크마크 경로
    path.moveTo(center.dx - animatedCheckSize * 0.3, center.dy);
    path.lineTo(
      center.dx - animatedCheckSize * 0.1,
      center.dy + animatedCheckSize * 0.2,
    );
    path.lineTo(
      center.dx + animatedCheckSize * 0.3,
      center.dy - animatedCheckSize * 0.2,
    );

    canvas.drawPath(path, paint);
  }

  void _drawXLine(Canvas canvas, Offset center, Size size) {
    final paint =
        Paint()
          ..color = Palette.grey
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

    final lineSize = size.width * 0.3;

    // 대각선 X
    canvas.drawLine(
      Offset(center.dx - lineSize, center.dy - lineSize),
      Offset(center.dx + lineSize, center.dy + lineSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckboxPainter oldDelegate) {
    return value != oldDelegate.value ||
        enabled != oldDelegate.enabled ||
        pressed != oldDelegate.pressed ||
        animationValue != oldDelegate.animationValue;
  }
}
