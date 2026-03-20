import 'package:flutter/material.dart';
import 'package:pot_g/gen/assets.gen.dart';

class PotLogo extends StatelessWidget {
  final bool showLogo;
  final String text;

  const PotLogo({super.key, this.showLogo = false, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLogo)
              AspectRatio(aspectRatio: 1, child: Assets.logo.color.image()),
            if (showLogo) const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 28,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
