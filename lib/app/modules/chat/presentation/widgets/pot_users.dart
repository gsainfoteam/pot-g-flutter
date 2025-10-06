import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_user.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_entity.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotUsers extends StatelessWidget {
  const PotUsers({super.key, required this.pot});

  final PotEntity pot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.chat_room.drawer.members.my,
          style: TextStyles.caption.copyWith(color: Palette.textGrey),
        ),
        const SizedBox(height: 8),
        PotUser(
          user: PotUserEntity(
            id: '',
            name: '일지매',
            isHost: true,
            isInPot: false,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.t.chat_room.drawer.members.passenger,
          style: TextStyles.caption.copyWith(color: Palette.textGrey),
        ),
        const SizedBox(height: 8),
        PotUser(
          user: PotUserEntity(
            id: '',
            name: '심청이',
            isHost: false,
            isInPot: false,
          ),
          onKick: () {},
        ),
        const SizedBox(height: 8),
        PotUser(
          user: PotUserEntity(
            id: '',
            name: '홍길동',
            isHost: false,
            isInPot: false,
          ),
          onKick: () {},
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.t.chat_room.drawer.members.invite,
                style: TextStyles.description.copyWith(color: Palette.grey),
              ),
              SizedBox(width: 6),
              Assets.icons.add.svg(),
            ],
          ),
        ),
      ],
    );
  }
}
