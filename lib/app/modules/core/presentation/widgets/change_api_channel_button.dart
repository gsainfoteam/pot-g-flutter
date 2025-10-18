import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/core/domain/enums/api_channel.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/api_channel_bloc.dart';

const hiddenHash =
    'b692cc52e03b75b017525a59c148cd62fb7c7e52fd991dc436fa29c19b6ff1e6';

class ChangeApiChannelButton extends StatefulWidget {
  const ChangeApiChannelButton({super.key});

  @override
  State<ChangeApiChannelButton> createState() => _ChangeApiChannelButtonState();
}

class _ChangeApiChannelButtonState extends State<ChangeApiChannelButton> {
  int _count = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PotPressable(
        onTap: () async {
          _timer?.cancel();
          _timer = Timer(const Duration(seconds: 1), () {
            setState(() => _count = 0);
          });
          setState(() => _count++);
          if (_count >= 15) {
            setState(() => _count = 0);
            final text = await showTextInputDialog(
              context: context,
              textFields: [DialogTextField()],
            );
            if (sha256.convert(utf8.encode(text?.first ?? '')).toString() ==
                    hiddenHash &&
                context.mounted) {
              final channel = await showConfirmationDialog(
                context: context,
                title: '',
                actions: ApiChannel.values
                    .map((e) => AlertDialogAction(key: e, label: e.name))
                    .toList(),
              );
              if (channel == null || !context.mounted) return;
              context.read<ApiChannelBloc>().add(
                ApiChannelEvent.setChannel(channel),
              );
              context.showToast(
                'api channel changed to ${channel.name}\n${channel.url}\n${channel.wsUrl}',
              );
            }
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
