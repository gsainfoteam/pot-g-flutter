import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class SystemMessage extends StatelessWidget {
  const SystemMessage({super.key, required this.message});

  final SystemMessageEntity message;

  @override
  Widget build(BuildContext context) {
    final trans = context.t.chat_room.system_messages;
    final text = switch (message.type) {
      SystemMessageType.userIn => trans.user_in.description(
        user: message.relatedUser.name,
      ),
      SystemMessageType.userLeave => trans.user_leave.description(
        user: message.relatedUser.name,
      ),
      SystemMessageType.userKicked => trans.user_kicked.description(
        user: message.relatedUser.name,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
          decoration: BoxDecoration(
            color: Color(0xff252525).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            text,
            style: TextStyles.caption.copyWith(color: Palette.grey),
          ),
        ),
      ),
    );
  }
}
