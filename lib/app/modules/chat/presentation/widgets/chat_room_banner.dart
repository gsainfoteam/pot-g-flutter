import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

class ChatRoomBanner extends StatelessWidget {
  const ChatRoomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6) + EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Palette.borderGrey),
      ),
      child: Row(
        children: [
          Assets.icons.bell.svg(
            colorFilter: ColorFilter.mode(Palette.primary, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chat Room Banner',
              style: TextStyles.body.copyWith(color: Palette.textGrey),
            ),
          ),
          const SizedBox(width: 8),
          PotIconButton(
            icon: Assets.icons.navArrowUp.svg(
              colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
