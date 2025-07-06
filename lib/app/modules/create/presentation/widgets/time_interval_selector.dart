import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/create/presentation/widgets/time_interval_form.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class TimeIntervalSelector extends StatelessWidget {
  const TimeIntervalSelector({
    super.key,
    required this.onStartChanged,
    required this.onEndChanged,
    this.startTime,
    this.endTime,
    this.disabled = false,
  });

  final DateTime? startTime;
  final DateTime? endTime;
  final Function(DateTime) onStartChanged;
  final Function(DateTime) onEndChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final startWidget = [
      Expanded(
        child: PotButton(
          onPressed: () async {
            final date = await TimeIntervalForm.select(
              context,
              startTime ?? DateTime.now().copyWith(hour: 0, minute: 0),
            );
            if (date != null) {
              onStartChanged(date);
            }
          },
          size: PotButtonSize.medium,
          child: Text(
            DateFormat.Hm().format(
              startTime ?? DateTime.now().copyWith(hour: 0, minute: 0),
            ),
            style: TextStyle(
              color:
                  startTime != null
                      ? Palette.primary
                      : disabled
                      ? Palette.grey
                      : null,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        context.t.create.time_interval.fields.start_time.from,
        style: TextStyles.caption,
      ),
    ];
    final endWidget = [
      Expanded(
        child: PotButton(
          onPressed: () async {
            final date = await TimeIntervalForm.select(
              context,
              endTime ?? DateTime.now().copyWith(hour: 23, minute: 59),
            );
            if (date != null) {
              onEndChanged(date);
            }
          },
          size: PotButtonSize.medium,
          child: Text(
            DateFormat.Hm().format(
              endTime ?? DateTime.now().copyWith(hour: 23, minute: 59),
            ),
            style: TextStyle(
              color:
                  endTime != null
                      ? Palette.primary
                      : disabled
                      ? Palette.grey
                      : null,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        context.t.create.time_interval.fields.end_time.to,
        style: TextStyles.caption,
      ),
    ];

    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
                context.t.create.time_interval.fields.start_time.input_first !=
                        'true'
                    ? startWidget.reversed.toList()
                    : startWidget,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
                context.t.create.time_interval.fields.end_time.input_first !=
                        'true'
                    ? endWidget.reversed.toList()
                    : endWidget,
          ),
        ),
      ],
    );
  }
}
