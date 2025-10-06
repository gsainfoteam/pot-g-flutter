import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotUser extends StatelessWidget {
  const PotUser({
    super.key,
    required this.user,
    this.onKick,
    required this.profileIndex,
  });

  final PotUserEntity user;
  final VoidCallback? onKick;
  final int profileIndex;

  Image getImageByIndex(int index) {
    final images = [
      Assets.images.jennie.image(),
      Assets.images.tree.image(),
      Assets.images.geni.image(),
      Assets.images.us.image(),
    ];
    return images[index % images.length];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Palette.borderGrey2, width: 0.5),
          ),
          child: ClipOval(child: getImageByIndex(profileIndex)),
        ),
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
            child: Text(context.t.chat_room.drawer.members.kick),
          ),
      ],
    );
  }
}
