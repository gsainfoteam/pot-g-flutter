import 'package:flutter/widgets.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

enum SmallAlertType { error, info }

class SmallAlert extends StatelessWidget {
  final String text;
  final SmallAlertType type;

  const SmallAlert({super.key, required this.text, required this.type});

  Color _getColor() {
    return switch (type) {
      SmallAlertType.error => Palette.warning,
      SmallAlertType.info => Palette.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.warningTriangle.svg(
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyles.caption.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
