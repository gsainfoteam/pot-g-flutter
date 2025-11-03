import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_bottom_sheet.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/hidden_menu_bloc.dart';
import 'package:pot_g/app/modules/core/presentation/widgets/hidden_menu_sheet.dart';

const hiddenHash =
    'b692cc52e03b75b017525a59c148cd62fb7c7e52fd991dc436fa29c19b6ff1e6';

class HiddenMenuButton extends StatelessWidget {
  const HiddenMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HiddenMenuBloc, HiddenMenuState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox.shrink(),
          enabled: (_) => const _Button(),
          disabled: (_) => const _Button(requireEnabled: true),
        );
      },
    );
  }
}

class _Button extends StatefulWidget {
  const _Button({this.requireEnabled = false});

  final bool requireEnabled;

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  int _count = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _tryEnable() async {
    final text = await showTextInputDialog(
      context: context,
      textFields: [DialogTextField()],
    );
    final hash = sha256.convert(utf8.encode(text?.first ?? '')).toString();
    if (hash != hiddenHash) return;
    if (!mounted) return;
    context.read<HiddenMenuBloc>().add(const HiddenMenuEvent.enable());
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (!widget.requireEnabled) {
            return PotBottomSheet.show(context, const HiddenMenuSheet());
          }
          _timer?.cancel();
          _timer = Timer(const Duration(seconds: 1), () {
            setState(() => _count = 0);
          });
          setState(() => _count++);
          if (_count >= 15) {
            setState(() => _count = 0);
            return _tryEnable();
          }
        },
        child: Container(
          color: Colors.black.withValues(
            alpha: _count < 5 ? 0 : ((_count - 5) / 20),
          ),
        ),
      ),
    );
  }
}
