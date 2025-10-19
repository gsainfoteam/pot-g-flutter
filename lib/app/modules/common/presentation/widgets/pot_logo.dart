import 'package:flutter/material.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotLogo extends StatelessWidget {
  const PotLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(aspectRatio: 1, child: Assets.logo.color.image()),
            const SizedBox(width: 4),
            Text(
              context.t.name,
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
