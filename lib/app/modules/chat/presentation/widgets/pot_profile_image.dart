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
      (Assets.images.jennie, Color(0xFFD3C5FC)),
      (Assets.images.tree, index > 3 ? Color(0xFFFFFBAD) : Color(0xFFF8F8F8)),
      (Assets.images.geni, Color(0xFFFFE0EC)),
      (Assets.images.us, Color(0xFFA2D2FF)),
    ];
    final sample = images[index % images.length];
    final image =
        inPot
            ? sample.$1.image()
            : sample.$1.image(
              colorBlendMode: BlendMode.color,
              color: Palette.grey,
            );
    final hsl = HSLColor.fromColor(sample.$2);
    final color =
        hsl
            .withHue(
              (hsl.hue + [0, 120, 240][(index ~/ images.length) % 3]) % 360,
            )
            .toColor();
    return Container(color: color, child: image);
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
      child: ClipOval(child: getImageByIndex(index, user.isInPot)),
    );
  }
}
