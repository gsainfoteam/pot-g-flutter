import 'package:flutter/material.dart';

class HiddenMenuSheet extends StatelessWidget {
  const HiddenMenuSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // final channel = await showConfirmationDialog(
    //   context: context,
    //   title: '',
    //   actions: ApiChannel.values
    //       .map((e) => AlertDialogAction(key: e, label: e.name))
    //       .toList(),
    // );
    // if (channel == null || !context.mounted) return;
    // final user = AuthBloc.userOf(context);
    // if (user != null) {
    //   return showAlertDialog(
    //     context: context,
    //     title: 'Warning',
    //     message:
    //         'You are already logged in. Please logout to change the API channel.',
    //   );
    // }
    // context.read<ApiChannelBloc>().add(
    //   ApiChannelEvent.setChannel(channel),
    // );
    // context.showToast(
    //   'api channel changed to ${channel.name}\n${channel.url}\n${channel.wsUrl}',
    // );
    return const Placeholder();
  }
}
