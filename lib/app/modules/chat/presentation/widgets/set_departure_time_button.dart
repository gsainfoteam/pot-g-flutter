import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_action_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_user_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/tooltip_overlay.dart';
import 'package:pot_g/app/modules/common/domain/enums/tooltip_type.dart';
import 'package:pot_g/app/modules/common/presentation/bloc/tooltip_cubit.dart';
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
  Timer? _tooltipTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndShowTooltip();
  }

  @override
  void didUpdateWidget(SetDepartureTimeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pot != widget.pot) {
      _checkAndShowTooltip();
    }
  }

  @override
  void dispose() {
    _tooltipTimer?.cancel();
    super.dispose();
  }

  Future<bool> _shouldShowTooltip() async {
    final pot = widget.pot;

    // Check conditions: departureTime == null && host && length > 1
    if (pot.departureTime != null) return false;
    if (!pot.meIsHost(context)) return false;
    if (pot.passengers.length <= 1) return false;

    return await context.read<TooltipCubit>().shouldShowTooltip(
      TooltipType.departureTime,
    );
  }

  Future<void> _checkAndShowTooltip() async {
    final shouldShow = await _shouldShowTooltip();
    if (!shouldShow) {
      _tooltipTimer?.cancel();
      _tooltipTimer = null;
      return;
    }
    if (!mounted) return;

    // Show tooltip after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _tooltipTimer = Timer(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        _controller.show();
      });
    });
  }

  Future<void> _handleTooltipClose() async {
    await context.read<TooltipCubit>().markTooltipAsShown(
      TooltipType.departureTime,
    );
  }

  Future<void> _onButtonPressed() async {
    if (_controller.isShowing) {
      _controller.hide();
      await _handleTooltipClose();
    }
    if (!mounted) return;
    L.c('setDepartureTime');
    await SetDepartureTimeButton.setDepartureTime(context, widget.pot);
  }

  @override
  Widget build(BuildContext context) {
    return TooltipOverlay(
      controller: _controller,
      content: Text(
        context.t.chat_room.set_departure_time.tooltip,
        style: TextStyles.description,
      ),
      onClose: _handleTooltipClose,
      child: PotIconButton(
        icon: Assets.icons.clock.svg(
          colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
        ),
        onPressed: _onButtonPressed,
      ),
    );
  }
}
