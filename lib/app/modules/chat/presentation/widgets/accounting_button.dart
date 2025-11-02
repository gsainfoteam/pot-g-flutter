import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/tooltip_overlay.dart';
import 'package:pot_g/app/modules/common/domain/enums/tooltip_type.dart';
import 'package:pot_g/app/modules/common/presentation/bloc/tooltip_cubit.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class AccountingButton extends StatefulWidget {
  const AccountingButton({super.key, required this.pot});

  final PotInfoEntity pot;

  static Future<void> setAccounting(
    BuildContext context,
    PotInfoEntity pot,
  ) async {
    final departureTime = pot.departureTime;
    if (departureTime == null) {
      context.showToast(context.t.chat_room.accounting.before_confirm);
      return;
    }
    final tenMinutesAfterDeparture = departureTime.add(
      const Duration(minutes: 10),
    );
    if (DateTime.now().isBefore(tenMinutesAfterDeparture)) {
      context.showToast(
        context.t.chat_room.accounting.dutch.errors.before_departure,
      );
      return;
    }
    await AccountingRoute(pot: pot).push(context);
  }

  @override
  State<AccountingButton> createState() => _AccountingButtonState();
}

class _AccountingButtonState extends State<AccountingButton> {
  final _controller = OverlayPortalController();
  Timer? _tooltipTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndShowTooltip();
  }

  @override
  void didUpdateWidget(AccountingButton oldWidget) {
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

  Future<void> _checkAndShowTooltip() async {
    final pot = widget.pot;
    if (!mounted) return;

    // Check condition: now > departureTime
    final departureTime = pot.departureTime;
    if (departureTime == null) return;
    if (!(DateTime.now().isAfter(departureTime))) return;

    // Check if tooltip should be shown
    final shouldShow = await context.read<TooltipCubit>().shouldShowTooltip(
      TooltipType.accounting,
    );
    if (!shouldShow) return;
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
      TooltipType.accounting,
    );
  }

  Future<void> _onButtonPressed() async {
    _controller.hide();
    await AccountingButton.setAccounting(context, widget.pot);
  }

  @override
  Widget build(BuildContext context) {
    return TooltipOverlay(
      controller: _controller,
      content: Text(context.t.chat_room.accounting.tooltip),
      onClose: _handleTooltipClose,
      child: PotIconButton(
        icon: Assets.icons.dollar.svg(
          colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
        ),
        onPressed: _onButtonPressed,
      ),
    );
  }
}
