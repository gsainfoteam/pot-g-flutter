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
                  final text = controller.text;
                  final cursorPosition = controller.selection.baseOffset;

                  if (cursorPosition > 0) {
                    final newText = controller.selection.isCollapsed
                        ? text.replaceRange(
                            cursorPosition - 1,
                            cursorPosition,
                            '',
                          )
                        : text.replaceRange(
                            controller.selection.start,
                            controller.selection.end,
                            '',
                          );
                    controller.value = controller.value.copyWith(
                      text: newText,
                      selection: TextSelection.collapsed(
                        offset: controller.selection.isCollapsed
                            ? cursorPosition - 1
                            : controller.selection.start,
                      ),
                    );
                  }
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
        final text = controller.text;
        final cursorPosition = controller.selection.baseOffset;

        if (cursorPosition >= 0) {
          final newText = text.replaceRange(
            cursorPosition,
            controller.selection.end,
            value.toString(),
          );
          controller.value = controller.value.copyWith(
            text: newText,
            selection: TextSelection.collapsed(offset: cursorPosition + 1),
          );
        }
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
