import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_info_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_user_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_user.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/general_dialog.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotUsers extends StatelessWidget {
  const PotUsers({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    final me = pot.getMe(context);
    final passengers = pot.usersInfo.users.where(
      (u) => u.isInPot && u.id != me?.id,
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
        ...passengers.expandIndexed(
          (index, e) => [
            if (index != 0) const SizedBox(height: 8),
            PotUser(
              user: e,
              onKick: me?.isHost ?? false ? () => _kickUser(context, e) : null,
              pot: pot,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _kickUser(BuildContext context, PotUserEntity user) async {
    if (pot.departureTime != null) {
      showOkAlertDialog(
        context: context,
        title: context.t.chat_room.drawer.members.departure_confirmed,
        message: context.t.chat_room.drawer.members.kick.departure_confirmed,
      );
      return;
    }
    final result = await showGeneralOkCancelAdaptiveDialog(
      title: context.t.chat_room.drawer.members.kick.confirm.title,
      child: Text.rich(
        context.t.chat_room.drawer.members.kick.confirm.description(
          user: TextSpan(
            text: user.name,
            style: TextStyle(color: Palette.primary),
          ),
        ),
      ),
      context: context,
    );
    if (result != OkCancelResult.ok) return;
    if (!context.mounted) return;
    context.read<PotInfoBloc>().add(PotInfoEvent.kickUser(user));
  }
}
