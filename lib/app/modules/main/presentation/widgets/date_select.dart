import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/date_time.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

class DateSelect extends StatefulWidget {
  const DateSelect({super.key, this.selectedDate, required this.onSelected});

  final DateTime? selectedDate;
  final void Function(DateTime) onSelected;

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  bool _isOpen = false;
  late DateTime? _selectedDate = widget.selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.white,
        border: Border.all(
          width: 1.5,
          color:
              _isOpen
                  ? Palette.primary
                  : _selectedDate == null
                  ? Palette.borderGrey
                  : Palette.dark,
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
                    _Calendar(
                      selectedDate: _selectedDate,
                      onSelected:
                          (date) => setState(() => _selectedDate = date),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PotButton(
                          onPressed:
                              _selectedDate == null
                                  ? null
                                  : () {
                                    setState(() => _isOpen = false);
                                    widget.onSelected(_selectedDate!);
                                  },
                          size: PotButtonSize.small,
                          child: Text('선택'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _isOpen = true),
                child: Container(
                  height: 48,
                  padding: EdgeInsets.all(10) + EdgeInsets.only(left: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child:
                            widget.selectedDate == null
                                ? Text(
                                  '전체 날짜',
                                  style: TextStyles.body.copyWith(
                                    color: Palette.textGrey,
                                  ),
                                )
                                : Text(
                                  DateFormat.yMd().add_E().format(
                                    widget.selectedDate!,
                                  ),
                                  style: TextStyles.body.copyWith(
                                    color: Palette.dark,
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
  const _Calendar({this.selectedDate, required this.onSelected});

  final DateTime? selectedDate;
  final void Function(DateTime) onSelected;

  @override
  State<_Calendar> createState() => __CalendarState();
}

class __CalendarState extends State<_Calendar> {
  late DateTime _currentMonth = widget.selectedDate ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(
                    () => _currentMonth = _currentMonth.subtractYears(1),
                  );
                },
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Assets.icons.fastArrowRight.svg(),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(
                    () => _currentMonth = _currentMonth.subtractMonths(1),
                  );
                },
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Assets.icons.navArrowRight.svg(),
                ),
              ),
              Spacer(),
              Text(
                DateFormat.yM().format(_currentMonth),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Palette.dark,
                  height: 1,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _currentMonth = _currentMonth.addMonths(1));
                },
                child: Assets.icons.navArrowRight.svg(),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _currentMonth = _currentMonth.addYears(1));
                },
                child: Assets.icons.fastArrowRight.svg(),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: List.generate(
              7,
              (i) => Expanded(
                child: Text(
                  DateFormat.E().format(
                    DateTime.now().startOfWeek().addDays(i),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        Column(
          children: List.generate(
            _currentMonth
                    .endOfMonth()
                    .endOfWeek()
                    .difference(_currentMonth.startOfMonth().startOfWeek())
                    .inDays ~/
                7,
            (i) => Row(
              children: List.generate(7, (j) {
                final date = _currentMonth
                    .startOfMonth()
                    .startOfWeek()
                    .addWeeks(i)
                    .addDays(j);
                return Expanded(
                  child: GestureDetector(
                    onTap:
                        () => setState(() {
                          widget.onSelected(date);
                          _currentMonth = date;
                        }),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            widget.selectedDate?.isSameDay(date) ?? false
                                ? Palette.primary
                                : null,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat.d().format(date),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            color:
                                widget.selectedDate?.isSameDay(date) ?? false
                                    ? Palette.primaryLight
                                    : date.isSameMonth(_currentMonth)
                                    ? Palette.textGrey
                                    : Palette.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
