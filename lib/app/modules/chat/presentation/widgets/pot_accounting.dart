import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_user.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotAccounting extends StatelessWidget {
  const PotAccounting({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    final requestedUsers = [
      ...pot.accountingInfo.requestedUsers,
      pot.accountingInfo.requestingUser,
    ].map((id) => pot.usersInfo.users.firstWhere((u) => (u.id == id)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.chat_room.drawer.accounting.amount,
          style: TextStyles.caption.copyWith(color: Palette.textGrey),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: NumberFormat.decimalPattern().format(
                  pot.accountingInfo.totalCost!,
                ),
              ),
              TextSpan(text: ' '),
              TextSpan(
                text: '/ ${pot.accountingInfo.requestedUsers.length + 1}',
                style: TextStyles.title4.copyWith(color: Palette.grey),
              ),
              TextSpan(
                text:
                    ' = ${NumberFormat.decimalPattern().format(pot.accountingInfo.costPerUser!)}',
              ),
            ],
          ),
          style: TextStyles.title2.copyWith(color: Palette.dark),
        ),
        const SizedBox(height: 20),
        Text(
          context.t.chat_room.drawer.accounting.status_title,
          style: TextStyles.caption.copyWith(color: Palette.textGrey),
        ),
        const SizedBox(height: 8),
        ...requestedUsers.expandIndexed(
          (index, e) => [
            if (index != 0) const SizedBox(height: 8),
            PotUser(user: e, pot: pot),
          ],
        ),
      ],
    );
  }
}
