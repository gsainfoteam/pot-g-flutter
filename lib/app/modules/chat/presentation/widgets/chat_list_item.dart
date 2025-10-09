import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/chat/domain/enums/pot_status.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_detail_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';

// TODO: add last chat messsage
// deleted in https://github.com/2paperstar/pot-g-flutter/commit/402e4d75e9d55f43f242d95e5a6fb4717bfd53fd

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, required this.pot});

  final PotDetailEntity pot;

  @override
  Widget build(BuildContext context) {
    final textColorTitle =
        pot.status == PotStatus.archived ? Palette.grey : Palette.dark;
    final textColorDescription =
        pot.status == PotStatus.archived ? Palette.grey : Palette.textGrey;

    return PotPressable(
      onTap: () => ChatRoomRoute(pot: pot).push(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              offset: Offset(3, 1),
              blurRadius: 8,
              color: Color(0x14000000),
            ),
            BoxShadow(
              offset: Offset(1, 3),
              blurRadius: 8,
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.only(bottom: 16, top: 12),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '팟 정보',
                    style: TextStyles.caption.copyWith(color: Palette.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '노선',
                        style: TextStyles.description.copyWith(
                          color: textColorTitle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        pot.route.name,
                        style: TextStyles.description.copyWith(
                          color: textColorDescription,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '날짜',
                        style: TextStyles.description.copyWith(
                          color: textColorTitle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat.yMd().add_E().format(pot.startsAt),
                        style: TextStyles.description.copyWith(
                          color: textColorDescription,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '시간',
                        style: TextStyles.description.copyWith(
                          color: textColorTitle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        pot.status == PotStatus.beforeConfirmed
                            ? '${DateFormat.Hm().format(pot.startsAt)}~${DateFormat.Hm().format(pot.endsAt)}'
                            : DateFormat.Hm().format(pot.startsAt),
                        style: TextStyles.description.copyWith(
                          color: textColorDescription,
                        ),
                      ),
                    ],
                  ),
                  if (pot.status == PotStatus.waitAccounting ||
                      pot.status == PotStatus.archived)
                    const SizedBox(height: 4),
                  if (pot.status == PotStatus.waitAccounting ||
                      pot.status == PotStatus.archived)
                    Row(
                      children: [
                        Text(
                          '정산',
                          style: TextStyles.description.copyWith(
                            color: textColorTitle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${NumberFormat('#,###').format(pot.accountingRequested)}원',
                          style: TextStyles.description.copyWith(
                            color: textColorDescription,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: _StatusChip(status: pot.status),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final PotStatus status;

  Color get color {
    return switch (status) {
      PotStatus.confirmed => Palette.primary,
      PotStatus.beforeConfirmed => Palette.grey,
      PotStatus.waitAccounting => Palette.warning,
      PotStatus.archived => Palette.borderGrey,
      PotStatus.accountingDone => Palette.primary,
    };
  }

  String get text {
    return switch (status) {
      PotStatus.confirmed => '확정',
      PotStatus.beforeConfirmed => '확정 전',
      PotStatus.waitAccounting => '정산 전',
      PotStatus.archived => '해산',
      PotStatus.accountingDone => '정산 완료',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (status == PotStatus.confirmed) ...[
                Icon(Icons.check, color: Palette.white, size: 20),
                const SizedBox(width: 4),
              ],
              Text(
                text,
                style: TextStyles.description.copyWith(color: Palette.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
