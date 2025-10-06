import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotInfo extends StatelessWidget {
  final PotInfoEntity pot;

  const PotInfo({super.key, required this.pot});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Field(
          label: context.t.chat_room.drawer.pot_info.route_info,
          value: pot.route.name,
        ),
        const SizedBox(height: 20),
        _Field(
          label: context.t.chat_room.drawer.pot_info.departure_date,
          value: DateFormat.yMd().add_E().format(pot.startsAt),
        ),
        const SizedBox(height: 20),
        _Field(
          label: context.t.chat_room.drawer.pot_info.departure_time,
          value:
              '${DateFormat.Hm().format(pot.startsAt)}~${DateFormat.Hm().format(pot.endsAt)}',
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.caption.copyWith(color: Palette.textGrey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyles.description.copyWith(color: Palette.dark),
        ),
      ],
    );
  }
}
