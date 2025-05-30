import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/date_time.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_entity.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';

class PotListItem extends StatelessWidget {
  const PotListItem({super.key, required this.pot});

  final PotEntity pot;

  @override
  Widget build(BuildContext context) {
    final disabled = pot.current == pot.total;
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 1),
            blurRadius: 8,
            color: Color(0x14000000),
          ),
          BoxShadow(
            offset: Offset(1, 3),
            blurRadius: 8,
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            decoration: BoxDecoration(
              color: disabled ? Palette.white : Palette.lightGrey,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '지송',
                  style: TextStyles.title3.copyWith(
                    color: disabled ? Palette.grey : Palette.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '001',
                  style: TextStyles.description.copyWith(
                    color: disabled ? Palette.grey : Palette.textGrey,
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(size: Size(1, 88), painter: _DashedLinePainter()),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.Md().add_E().format(pot.startsAt),
                        style: TextStyles.caption.copyWith(
                          color: disabled ? Palette.grey : Palette.textGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DefaultTextStyle.merge(
                        style: TextStyles.title1.copyWith(
                          color: disabled ? Palette.grey : Palette.dark,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(DateFormat.Hm().format(pot.startsAt)),
                            Text('~'),
                            Text(DateFormat.Hm().format(pot.endsAt)),
                            if (!pot.startsAt.isSameDay(pot.endsAt))
                              Text(
                                'D+1',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0.66,
                                  letterSpacing: -0.025 * 12,
                                  color:
                                      disabled
                                          ? Palette.grey
                                          : Palette.textGrey,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    '${pot.current}/${pot.total}',
                    style: TextStyles.title1.copyWith(
                      color: disabled ? Palette.grey : Palette.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 8, dashSpace = 8, startY = 0;
    final paint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round;
    canvas.clipRect(Offset.zero & size);
    canvas.save();
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, min(startY + dashWidth, size.height)),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
