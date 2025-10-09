import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/chat/domain/enums/pot_status.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_detail_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';

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
        height:
            (pot.status == PotStatus.waitAccounting ||
                    pot.status == PotStatus.archived)
                ? 203
                : 180,
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.all(Radius.circular(11)),
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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Palette.borderGrey, width: 1.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          '팟 정보',
                          style: TextStyles.caption.copyWith(
                            color: Palette.grey,
                          ),
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

                        const SizedBox(height: 16),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        if (pot.status == PotStatus.confirmed)
                          Container(
                            width: 68,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Palette.primary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Palette.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '확정',
                                  style: TextStyles.description.copyWith(
                                    color: Palette.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (pot.status == PotStatus.beforeConfirmed)
                          Container(
                            width: 65,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Palette.grey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                '확정 전',
                                style: TextStyles.description.copyWith(
                                  color: Palette.white,
                                ),
                              ),
                            ),
                          )
                        else if (pot.status == PotStatus.waitAccounting)
                          Container(
                            width: 65,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Palette.warning,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '정산 전',
                                  style: TextStyles.description.copyWith(
                                    color: Palette.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (pot.status == PotStatus.archived)
                          Container(
                            width: 48,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Palette.borderGrey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '해산',
                                  style: TextStyles.description.copyWith(
                                    color: Palette.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Palette.lightGrey, height: 1, thickness: 1),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'chat',
                    style: TextStyles.caption.copyWith(color: Palette.grey),
                  ),
                  Row(
                    children: [
                      Text(
                        '저는 축지법이 더 편하긴 해요',
                        style: TextStyles.body.copyWith(color: Palette.dark),
                      ),
                      Spacer(),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Palette.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
