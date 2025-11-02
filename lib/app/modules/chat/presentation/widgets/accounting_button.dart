import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/tooltip_overlay.dart';
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

  @override
  Widget build(BuildContext context) {
    return TooltipOverlay(
      controller: _controller,
      content: Text(context.t.chat_room.accounting.tooltip),
      child: PotIconButton(
        icon: Assets.icons.dollar.svg(
          colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
        ),
        onPressed: () async {
          await AccountingButton.setAccounting(context, widget.pot);
        },
      ),
    );
  }
}
