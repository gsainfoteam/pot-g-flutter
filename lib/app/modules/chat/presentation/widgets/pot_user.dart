import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_profile_image.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotUser extends StatelessWidget {
  const PotUser({
    super.key,
    required this.user,
    this.onKick,
    required this.pot,
  });

  final PotUserEntity user;
  final PotInfoEntity pot;
  final VoidCallback? onKick;

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
            if (user.isHost) ...[
              SizedBox(width: 4),
              Text(
                context.t.chat_room.drawer.members.host,
                style: TextStyles.caption.copyWith(color: Palette.grey),
              ),
            ],
          ],
        ),
        Spacer(),
        if (onKick != null)
          PotButton(
            onPressed: onKick,
            size: PotButtonSize.tiny,
            child: Text(context.t.chat_room.drawer.members.kick.action),
          ),
      ],
    );
  }
}
