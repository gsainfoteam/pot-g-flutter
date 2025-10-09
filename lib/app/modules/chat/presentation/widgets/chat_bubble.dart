import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/bubble.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_profile_image.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.user,
    this.isFirst = false,
    required this.pot,
  });

  final String message;
  final PotUserEntity? user;
  final bool isFirst;
  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      isFirst: isFirst,
      isMe: user == null,
      profileImage:
          user == null ? null : PotProfileImage(user: user!, pot: pot),
      name: user?.name,
      child: Text(
        message,
        style: TextStyles.description.copyWith(
          color: user == null ? Palette.primaryLight : Palette.textGrey,
        ),
      ),
    );
  }
}
