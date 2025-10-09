import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_user.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotUsers extends StatelessWidget {
  const PotUsers({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    final meUser = AuthBloc.userOf(context);
    final me = pot.usersInfo.users.firstWhereOrNull((u) => u.id == meUser?.id);
    final passengers = pot.usersInfo.users.where(
      (u) => u.isInPot && u.id != meUser?.id,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.chat_room.drawer.members.my,
          style: TextStyles.caption.copyWith(color: Palette.textGrey),
        ),
        const SizedBox(height: 8),
        if (me != null) PotUser(user: me, pot: pot),
        const SizedBox(height: 20),
        Text(
          context.t.chat_room.drawer.members.passenger,
          style: TextStyles.caption.copyWith(color: Palette.textGrey),
        ),
        const SizedBox(height: 8),
        ...passengers.indexed.expand(
          (e) => [
            if (e.$1 != 0) const SizedBox(height: 8),
            PotUser(
              user: e.$2,
              onKick: me?.isHost ?? false ? () {} : null,
              pot: pot,
            ),
          ],
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
