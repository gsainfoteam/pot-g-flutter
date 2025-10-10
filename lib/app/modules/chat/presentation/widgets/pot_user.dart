import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_profile_image.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_checkbox.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

enum PayStatus { payer, done, notRequested, notPaid }

class PotUser extends StatelessWidget {
  const PotUser({
    super.key,
    required this.user,
    this.onKick,
    required this.pot,
    this.payStatus,
    this.onPay,
  });

  final PotUserEntity user;
  final PotInfoEntity pot;
  final VoidCallback? onKick;
  final PayStatus? payStatus;
  final void Function(bool? value)? onPay;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PotProfileImage(user: user, pot: pot),
        SizedBox(width: 8),
        Row(
          children: [
            Text(
              user.name,
              style: TextStyles.description.copyWith(color: Palette.dark),
            ),
            if (user.isHost && payStatus == null) ...[
              SizedBox(width: 4),
              Text(
                context.t.chat_room.drawer.members.host,
                style: TextStyles.caption.copyWith(color: Palette.grey),
              ),
            ],
          ],
        ),
        Spacer(),
        if (onKick != null && payStatus == null)
          PotButton(
            onPressed: onKick,
            size: PotButtonSize.tiny,
            child: Text(context.t.chat_room.drawer.members.kick.action),
          ),
        if (payStatus != null) ...[
          Text(
            payStatus == PayStatus.payer
                ? context.t.chat_room.drawer.accounting.status.payer
                : payStatus == PayStatus.done
                ? context.t.chat_room.drawer.accounting.status.done
                : payStatus == PayStatus.notRequested
                ? context.t.chat_room.drawer.accounting.status.not_requested
                : context.t.chat_room.drawer.accounting.status.before,
            style: TextStyles.caption.copyWith(
              color:
                  payStatus == PayStatus.done ? Palette.textGrey : Palette.grey,
            ),
          ),
          const SizedBox(width: 2),
          PotCheckbox(
            value: payStatus == PayStatus.notPaid ? false : true,
            enabled:
                payStatus == PayStatus.notRequested ||
                        payStatus == PayStatus.payer
                    ? false
                    : true,
            onChanged: (v) => onPay?.call(v ?? false),
          ),
        ],
      ],
    );
  }
}
