import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/date_time.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_summary_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

const _lineWidth = 1.0;
const _radius = 5.0;

class PotListItem extends StatelessWidget {
  const PotListItem({super.key, required this.pot});

  final PotSummaryEntity pot;

  @override
  Widget build(BuildContext context) {
    final version = kDebugMode ? 2 : 1;
    return PotPressable(
      onTap: pot.disabled
          ? null
          : () {
              L.c('pot', properties: {'potId': pot.id, 'potName': pot.name});
              InvitedRoute(id: pot.id).push(context);
            },
      child: version == 1 ? _ItemV1(pot: pot) : _ItemV2(pot: pot),
    );
  }
}

class _ItemV1 extends StatelessWidget {
  const _ItemV1({required this.pot});
  final PotSummaryEntity pot;

  @override
  Widget build(BuildContext context) {
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
              color: pot.disabled ? Palette.white : Palette.lightGrey,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pot.name.substring(0, 2),
                  style: TextStyles.title3.copyWith(
                    color: pot.disabled ? Palette.grey : Palette.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pot.name.substring(2),
                  style: TextStyles.description.copyWith(
                    color: pot.disabled ? Palette.grey : Palette.textGrey,
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            size: Size(1, 88),
            painter: _DashedLinePainter(dashWidth: 4, dashSpace: 4, startY: 0),
          ),
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
                          color: pot.disabled ? Palette.grey : Palette.textGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DefaultTextStyle.merge(
                        style: TextStyles.title1.copyWith(
                          color: pot.disabled ? Palette.grey : Palette.dark,
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
                                  color: pot.disabled
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
                      color: pot.disabled ? Palette.grey : Palette.primary,
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

class _ItemV2 extends StatelessWidget {
  const _ItemV2({required this.pot});
  final PotSummaryEntity pot;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 2),
            blurRadius: 4,
            color: Color(0x0D000000),
          ),
          BoxShadow(
            offset: Offset(-1, -1),
            blurRadius: 6,
            color: Color(0x09000000),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: ClipPath(
                  clipper: _HoleClipper(isLeft: false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    color: Palette.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pot.route.name,
                          style: TextStyles.description.copyWith(
                            color: pot.disabled
                                ? Palette.grey
                                : Palette.textGrey,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: DateFormat.Hm().format(pot.startsAt),
                              ),
                              TextSpan(text: '~'),
                              TextSpan(
                                text: DateFormat.Hm().format(pot.endsAt),
                              ),
                              if (!pot.startsAt.isSameDay(pot.endsAt))
                                TextSpan(
                                  text: 'D+1',
                                  style: TextStyles.description.copyWith(
                                    fontSize: 12,

                                    color: pot.disabled
                                        ? Palette.grey
                                        : Palette.textGrey,
                                  ),
                                ),
                            ],
                          ),
                          style: TextStyles.title3.copyWith(
                            color: pot.disabled ? Palette.grey : Palette.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: _radius),
                child: CustomPaint(
                  foregroundPainter: _DashedLinePainter(
                    dashWidth: 4,
                    dashSpace: 4,
                    startY: 0,
                  ),
                  child: Container(width: _lineWidth),
                ),
              ),
              ClipPath(
                clipper: _HoleClipper(isLeft: true),
                child: Container(
                  color: Palette.primaryLight,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.t.create.capacity.fields.max_capacity.label,
                        style: TextStyles.caption2.copyWith(
                          color: Palette.textGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 50,
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: pot.current.toString(),
                                style: TextStyles.title4.copyWith(
                                  color: Palette.primary,
                                ),
                              ),
                              TextSpan(text: '/${pot.total}'),
                            ],
                          ),
                          style: TextStyles.body.copyWith(
                            color: Palette.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final double startY;
  _DashedLinePainter({
    required this.dashWidth,
    required this.dashSpace,
    required this.startY,
  });
  @override
  void paint(Canvas canvas, Size size) {
    double startY = this.startY;
    canvas.drawRect(
      Offset.zero & Size(size.width / 2, size.height),
      Paint()..color = Palette.white,
    );
    canvas.drawRect(
      Offset(size.width / 2, 0) & Size(size.width / 2, size.height),
      Paint()..color = Palette.primaryLight,
    );
    final paint = Paint()
      ..color = Palette.borderGrey
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.save();
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, min(startY + dashWidth, size.height)),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
}

class _HoleClipper extends CustomClipper<Path> {
  final bool isLeft;
  final double radius = _radius;
  final double gap = _lineWidth;
  _HoleClipper({required this.isLeft});
  @override
  Path getClip(Size size) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addOval(
        Rect.fromCenter(
          center: isLeft
              ? size.topLeft(Offset(-gap / 2, 0))
              : size.topRight(Offset(gap / 2, 0)),
          width: radius * 2,
          height: radius * 2,
        ),
      )
      ..addOval(
        Rect.fromCenter(
          center: isLeft
              ? size.bottomLeft(Offset(-gap / 2, 0))
              : size.bottomRight(Offset(gap / 2, 0)),
          width: radius * 2,
          height: radius * 2,
        ),
      );
  }

  @override
  bool shouldReclip(_HoleClipper oldClipper) => true;
}

extension on PotSummaryEntity {
  bool get disabled => current == total;
}
