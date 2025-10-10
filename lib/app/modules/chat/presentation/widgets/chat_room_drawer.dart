import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_info_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_info.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_users.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class ChatRoomDrawer extends StatelessWidget {
  const ChatRoomDrawer({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PotInfo(pot: pot),
              const SizedBox(height: 20),
              Container(height: 1, color: Palette.borderGrey2),
              const SizedBox(height: 20),
              PotUsers(pot: pot),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PotPressable(
                    onTap: () => _leave(context),
                    child: Text(
                      context.t.chat_room.drawer.actions.leave.action,
                      style: TextStyles.caption.copyWith(
                        color: Palette.grey,
                        decoration: TextDecoration.underline,
                        decorationColor: Palette.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _leave(BuildContext context) async {
    if (pot.departureTime != null) {
      showOkAlertDialog(
        context: context,
        title: context.t.chat_room.drawer.members.departure_confirmed,
        message: context.t.chat_room.drawer.actions.leave.departure_confirmed,
      );
      return;
    }
    final result = await showOkCancelAlertDialog(
      context: context,
      title: context.t.chat_room.drawer.actions.leave.confirm.title,
      message: context.t.chat_room.drawer.actions.leave.confirm.description,
    );
    if (result != OkCancelResult.ok) return;
    if (!context.mounted) return;
    context.read<PotInfoBloc>().add(PotInfoEvent.leavePot());
  }
}
