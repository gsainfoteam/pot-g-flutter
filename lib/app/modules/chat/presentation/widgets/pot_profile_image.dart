import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/gen/assets.gen.dart';

class PotProfileImage extends StatelessWidget {
  const PotProfileImage({super.key, required this.user, required this.pot});

  final PotUserEntity user;
  final PotInfoEntity pot;

  Widget getImageByIndex(int index, bool inPot) {
    final images = [
      (
        Assets.images.jennie,
        [Color(0xffd3c5fc), Color(0xffffd8f5), Color(0xffd0ddff)],
      ),
      (
        Assets.images.tree,
        [Color(0xfff8f8f8), Color(0xfff0fff4), Color(0xffe9f3ff)],
      ),
      (
        Assets.images.geni,
        [Color(0xffffe0ec), Color(0xfffff3dc), Color(0xfffdb5a6)],
      ),
      (
        Assets.images.us,
        [Color(0xffa2d2ff), Color(0xff98c2d0), Color(0xff345c80)],
      ),
    ];
    final sample = images[index % images.length];
    final image = inPot
        ? sample.$1.svg()
        : sample.$1.svg(
            colorFilter: ColorFilter.mode(Palette.grey, BlendMode.color),
          );
    final color = sample.$2[index ~/ images.length];
    return Container(color: color, child: image);
  }

  @override
  Widget build(BuildContext context) {
    final index = pot.usersInfo.users.indexed
        .firstWhereOrNull((e) => e.$2.id == user.id)
        ?.$1;
    if (index == null) return SizedBox(width: 40, height: 40);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Palette.borderGrey, width: 0.5),
      ),
      child: ClipOval(child: getImageByIndex(index, user.isInPot)),
    );
  }
}
