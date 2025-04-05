import 'package:flutter/material.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

class PotPathSelect extends StatefulWidget {
  const PotPathSelect({super.key});

  @override
  State<PotPathSelect> createState() => _PotPathSelectState();
}

class _PotPathSelectState extends State<PotPathSelect> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 48,
              padding: EdgeInsets.all(10) + EdgeInsets.only(left: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      '전체 노선',
                      style: TextStyles.body.copyWith(color: Palette.textGrey),
                    ),
                  ),
                  if (!_isOpen)
                    Assets.icons.navArrowDown.svg(
                      colorFilter: ColorFilter.mode(
                        Palette.dark,
                        BlendMode.srcIn,
                      ),
                    ),
                ],
              ),
            ),
            if (_isOpen) ...[
              Container(
                height: 48,
                padding: EdgeInsets.all(10) + EdgeInsets.only(left: 6),
                child: Text(
                  '지스트 → 송정역',
                  style: TextStyles.body.copyWith(color: Palette.textGrey),
                ),
              ),
              Container(
                height: 48,
                padding: EdgeInsets.all(10) + EdgeInsets.only(left: 6),
                child: Text(
                  '지스트 → 송정역',
                  style: TextStyles.body.copyWith(color: Palette.textGrey),
                ),
              ),
              Container(
                height: 48,
                padding: EdgeInsets.all(10) + EdgeInsets.only(left: 6),
                child: Text(
                  '지스트 → 송정역',
                  style: TextStyles.body.copyWith(color: Palette.textGrey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
