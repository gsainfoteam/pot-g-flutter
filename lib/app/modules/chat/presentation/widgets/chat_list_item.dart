import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/date_time.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_entity.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, required this.pot});

  final PotEntity pot;

  @override
  Widget build(BuildContext context) {
    final disabled = pot.current == pot.total;

    return Container(
      height: 180,
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
                        style: TextStyles.caption.copyWith(color: Palette.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '노선',
                            style: TextStyles.description.copyWith(
                              color: Palette.dark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '송정역 → 지스트',
                            style: TextStyles.description.copyWith(
                              color: Palette.textGrey,
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
                              color: Palette.dark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat(
                              'yyyy년 MM월 dd일 E요일',
                              'ko_KR',
                            ).format(pot.startsAt),
                            style: TextStyles.description.copyWith(
                              color: Palette.textGrey,
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
                              color: Palette.dark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat.Hm().format(pot.startsAt),
                            style: TextStyles.description.copyWith(
                              color: Palette.textGrey,
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
                            Icon(Icons.check, color: Palette.white, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '확정',
                              style: TextStyles.description.copyWith(
                                color: Palette.white,
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
    );
  }
}
