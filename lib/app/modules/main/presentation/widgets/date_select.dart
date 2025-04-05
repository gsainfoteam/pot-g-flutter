import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

class DateSelect extends StatefulWidget {
  const DateSelect({super.key});

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isOpen = !_isOpen),
      child: Container(
        decoration: BoxDecoration(
          color: Palette.white,
          border: Border.all(
            width: 1.5,
            color: _isOpen ? Palette.primary : Palette.borderGrey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child:
            _isOpen
                ? Padding(
                  padding: const EdgeInsets.all(15) - EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Calendar(),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PotButton(
                            onPressed: () {},
                            size: PotButtonSize.small,
                            child: Text('선택'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                : Container(
                  height: 48,
                  padding: EdgeInsets.all(10) + EdgeInsets.only(left: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '전체 날짜',
                          style: TextStyles.body.copyWith(
                            color: Palette.textGrey,
                          ),
                        ),
                      ),
                      if (!_isOpen)
                        Assets.icons.calendar.svg(
                          colorFilter: ColorFilter.mode(
                            Palette.dark,
                            BlendMode.srcIn,
                          ),
                        ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class _Calendar extends StatefulWidget {
  const _Calendar();

  @override
  State<_Calendar> createState() => __CalendarState();
}

class __CalendarState extends State<_Calendar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          RotatedBox(quarterTurns: 2, child: Assets.icons.fastArrowRight.svg()),
          const SizedBox(width: 20),
          RotatedBox(quarterTurns: 2, child: Assets.icons.navArrowRight.svg()),
          Spacer(),
          Text(
            '2025년 4월',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Palette.dark,
            ),
          ),
          Spacer(),
          Assets.icons.navArrowRight.svg(),
          const SizedBox(width: 20),
          Assets.icons.fastArrowRight.svg(),
        ],
      ),
    );
  }
}
