import 'package:flutter/material.dart';
import 'package:pot_g/app/values/palette.dart';

class PotGBottomSheet extends StatelessWidget {
  const PotGBottomSheet({
    super.key,
    required this.child,
    this.smallPadding = false,
  });

  final Widget child;
  final bool smallPadding;

  static Future<T?> show<T>(BuildContext context, Widget child) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => PotGBottomSheet(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, -2),
            blurRadius: 8,
            color: Color(0x0d000000),
          ),
          BoxShadow(
            offset: Offset(-3, -2),
            blurRadius: 8,
            color: Color(0x0d000000),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
              smallPadding
                  ? EdgeInsets.only(left: 16, right: 16, bottom: 20)
                  : EdgeInsets.only(left: 24, right: 24, bottom: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Palette.grey,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
