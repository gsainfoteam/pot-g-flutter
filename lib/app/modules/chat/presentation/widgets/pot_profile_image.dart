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
    final index =
        pot.usersInfo.users.indexed
            .firstWhereOrNull((e) => e.$2.id == user.id)
            ?.$1;
    if (index == null) return SizedBox(width: 40, height: 40);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Palette.borderGrey2, width: 0.5),
      ),
      child: ClipOval(child: getImageByIndex(index)),
    );
  }
}
