import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/bubble.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class FofoBubble extends StatelessWidget {
  const FofoBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Bubble(
      isFirst: true,
      isMe: false,
      profileImage: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Palette.borderGrey2, width: 0.5),
        ),
        child: ClipOval(child: Assets.images.fofo.image()),
      ),
      name: context.t.chat_room.fofo.name,
      child: Text(context.t.chat_room.fofo.name),
    );
  }
}
