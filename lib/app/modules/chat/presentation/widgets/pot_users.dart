import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_action_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_user_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_user.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/general_dialog.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/api_channel_bloc.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';
import 'package:share_plus/share_plus.dart';

class PotUsers extends StatelessWidget {
  const PotUsers({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    final me = pot.getMe(context);
    final passengers = pot.getPassengersExceptMe(context);
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
              onKick: me?.isHost ?? false
                  ? () {
                      L.c(
                        'kick',
                        properties: {'userId': e.id, 'potId': pot.id},
                      );
                      _kickUser(context, e);
                    }
                  : null,
              pot: pot,
            ),
          ],
        ),
        PotPressable(
          onTap: () {
            L.c('copyLink', properties: {'potId': pot.id});
            final inviteText = context.t.chat_room.drawer.members.invite;
            if (pot.departureTime != null) {
              showOkAlertDialog(
                context: context,
                title: inviteText.departure_confirmed.title,
                message: inviteText.departure_confirmed.description,
              );
              return;
            }
            if (pot.passengers.length == pot.usersInfo.total) {
              showOkAlertDialog(
                context: context,
                title: inviteText.fulled.title,
                message: inviteText.fulled.description,
              );
              return;
            }
            final appLinkUrl = context
                .read<ApiChannelBloc>()
                .state
                .channel
                ?.appLinkUrl;
            if (appLinkUrl == null) return;
            SharePlus.instance.share(
              ShareParams(
                uri: Uri.parse('${appLinkUrl}invited/${pot.id}'),
                // https://github.com/fluttercommunity/plus_plugins/issues/3645#issuecomment-3360156193
                sharePositionOrigin: Rect.fromLTWH(0, 0, 1, 1),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.t.chat_room.drawer.members.invite.action,
                  style: TextStyles.description.copyWith(color: Palette.grey),
                ),
                SizedBox(width: 6),
                Assets.icons.add.svg(),
              ],
            ),
          ),
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
    context.read<PotActionBloc>().add(PotActionEvent.kickUser(pot, user));
  }
}
