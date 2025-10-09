import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/fofo_action_button_type.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/bubble.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class FofoBubble extends StatelessWidget {
  const FofoBubble({super.key, required this.message});

  final FofoChatEntity message;

  String action(BuildContext context, FofoActionButtonType type) {
    final fofo = context.t.chat_room.fofo.actions;
    return switch (type) {
      FofoActionButtonType.departureConfirm => fofo.departure_confirm,
      FofoActionButtonType.taxiCall => fofo.taxi_call,
      FofoActionButtonType.accountingRequest => fofo.accounting_request,
      FofoActionButtonType.accountingInfoCheck => fofo.accounting_info_check,
      FofoActionButtonType.accountingProcess => fofo.accounting_process,
    };
  }

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
      child: Column(
        children: [
          Text(
            message.content.split('\n').first.replaceAll('**', ''),
            style: TextStyles.title4.copyWith(color: Palette.textGrey),
          ),
          const SizedBox(height: 8),
          Text(
            message.content.split('\n').sublist(1).join('\n'),
            style: TextStyles.description.copyWith(color: Palette.textGrey),
          ),
          const SizedBox(height: 8),
          Column(
            children:
                message.actionButtons
                    .expandIndexed(
                      (index, e) => [
                        if (index != 0) const SizedBox(height: 8),
                        PotButton(
                          onPressed: () {},
                          size: PotButtonSize.medium,
                          variant:
                              index == message.actionButtons.length - 1
                                  ? PotButtonVariant.outlined
                                  : null,
                          child: Text(action(context, e)),
                        ),
                      ],
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
