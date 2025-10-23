import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class AccountingButton extends StatelessWidget {
  const AccountingButton({super.key, required this.pot});

  final PotInfoEntity pot;

  static Future<void> setAccounting(
    BuildContext context,
    PotInfoEntity pot,
  ) async {
    if (pot.departureTime == null) {
      context.showToast(context.t.chat_room.accounting.before_confirm);
      return;
    }
    await AccountingRoute(pot: pot).push(context);
  }

  @override
  Widget build(BuildContext context) {
    return PotIconButton(
      icon: Assets.icons.dollar.svg(
        colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
      ),
      onPressed: () async {
        await setAccounting(context, pot);
      },
    );
  }
}
