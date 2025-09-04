import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';

class Keypad extends StatelessWidget {
  const Keypad({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyle(fontSize: 25, color: Colors.black),
      child: Column(
        children: [
          Row(
            children: [
              _buildNumberButton(1),
              _buildNumberButton(2),
              _buildNumberButton(3),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildNumberButton(4),
              _buildNumberButton(5),
              _buildNumberButton(6),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildNumberButton(7),
              _buildNumberButton(8),
              _buildNumberButton(9),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: SizedBox()),
              _buildNumberButton(0),
              _Button(
                onTap: () {
                  controller.text = controller.text.substring(
                    0,
                    max(controller.text.length - 1, 0),
                  );
                },
                child: Icon(Icons.backspace_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(int value) {
    return _Button(
      onTap: () {
        controller.text += value.toString();
      },
      child: Text(value.toString()),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PotPressable(
        hitTestBehavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(height: 48, child: Center(child: child)),
      ),
    );
  }
}
