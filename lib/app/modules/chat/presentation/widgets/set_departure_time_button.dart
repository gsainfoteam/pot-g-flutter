import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_action_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_user_extension.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/general_dialog.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class SetDepartureTimeButton extends StatefulWidget {
  const SetDepartureTimeButton({super.key, required this.pot});

  final PotInfoEntity pot;

  static Future<void> setDepartureTime(
    BuildContext context,
    PotInfoEntity pot,
  ) async {
    if (!pot.meIsHost(context)) {
      context.showToast(
        context.t.chat_room.set_departure_time.host_only.description,
      );
      return;
    }
    if (pot.departureTime != null) {
      context.showToast(
        context.t.chat_room.set_departure_time.already_set.description,
      );
      return;
    }
    if (pot.passengers.length == 1) {
      context.showToast(
        context.t.chat_room.set_departure_time.you_only.description,
      );
      return;
    }
    L.v('setDepartureTime');
    DateTime date = DateTime.now();
    final result = await showGeneralOkCancelAdaptiveDialog(
      context: context,
      title: context.t.chat_room.set_departure_time.clock.title,
      child: SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          initialDateTime: date,
          onDateTimeChanged: (value) => date = value,
          mode: CupertinoDatePickerMode.time,
        ),
      ),
      okLabel: context.t.common.confirm,
    );
    if (result != OkCancelResult.ok) return;
    if (!context.mounted) return;
    L.v('departureTimeConfirm', from: 'setDepartureTime');
    final result2 = await showOkCancelAlertDialog(
      context: context,
      title: context.t.chat_room.set_departure_time.confirm.title,
      message: context.t.chat_room.set_departure_time.confirm.description(
        route: pot.route.name,
        time: DateFormat.jm().format(date),
      ),
    );
    if (result2 != OkCancelResult.ok) return;
    L.c('confirmDepartureTime', from: 'departureTimeConfirm');
    if (!context.mounted) return;
    context.read<PotActionBloc>().add(
      PotActionEvent.setDepartureTime(pot, date),
    );
  }

  @override
  State<SetDepartureTimeButton> createState() => _SetDepartureTimeButtonState();
}

class _SetDepartureTimeButtonState extends State<SetDepartureTimeButton> {
  final _controller = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: _controller,
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
                        child: Text(
                          context.t.chat_room.set_departure_time.tooltip,
                          style: TextStyles.description,
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
      child: PotIconButton(
        icon: Assets.icons.clock.svg(
          colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
        ),
        onPressed: () async {
          _controller.show();
          // L.c('setDepartureTime');
          // await SetDepartureTimeButton.setDepartureTime(context, widget.pot);
        },
      ),
    );
  }
}

// CustomClipper for a circular shape
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
