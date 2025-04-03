import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pot_g/app/values/palette.dart';

class PotGToggle extends StatelessWidget {
  const PotGToggle({super.key, required this.value, required this.onChanged});

  final bool value;
  final void Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 60,
        height: 33,
        decoration: BoxDecoration(
          color: value ? Palette.primary : Palette.grey,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.5),
        child: Stack(
          children: [
            AnimatedAlign(
              curve: Curves.easeOutQuad,
              duration: const Duration(milliseconds: 100),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 25.5,
                height: 25.5,
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
