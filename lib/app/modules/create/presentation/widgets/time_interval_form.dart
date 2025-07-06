import 'package:flutter/cupertino.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_g_bottom_sheet.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/gen/strings.g.dart';

class TimeIntervalForm extends StatefulWidget {
  const TimeIntervalForm({super.key, required this.initialDateTime});

  final DateTime initialDateTime;

  static Future<DateTime?> select(
    BuildContext context,
    DateTime initialDateTime,
  ) {
    return PotGBottomSheet.show(
      context,
      TimeIntervalForm(initialDateTime: initialDateTime),
    );
  }

  @override
  State<TimeIntervalForm> createState() => _TimeIntervalFormState();
}

class _TimeIntervalFormState extends State<TimeIntervalForm> {
  late DateTime selectedDate = widget.initialDateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Palette.lightGrey,
          ),
          child: SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              initialDateTime: widget.initialDateTime,
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PotButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                variant: PotButtonVariant.outlined,
                child: Text(context.t.common.cancel),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PotButton(
                onPressed: () {
                  Navigator.pop(context, selectedDate);
                },
                variant: PotButtonVariant.emphasized,
                child: Text(context.t.common.confirm),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
