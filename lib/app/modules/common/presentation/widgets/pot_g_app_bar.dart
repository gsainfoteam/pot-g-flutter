import 'package:flutter/material.dart';
import 'package:pot_g/app/values/palette.dart';

class PotGAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PotGAppBar({super.key, this.actions = const []});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              const SizedBox(width: 16),
              SizedBox(
                height: 32,
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(color: Palette.primary),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '팟쥐',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Row(children: actions),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
