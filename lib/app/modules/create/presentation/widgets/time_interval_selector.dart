import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class TimeIntervalSelector extends StatelessWidget {
  const TimeIntervalSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final startWidget = [
      Expanded(
        child: PotButton(
          onPressed: () {},
          size: PotButtonSize.medium,
          child: Text('00:00'),
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
          onPressed: () {},
          size: PotButtonSize.medium,
          child: Text('23:59'),
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
