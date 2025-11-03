import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/core/domain/enums/api_channel.dart';
import 'package:pot_g/app/modules/core/domain/enums/hidden_menu_level.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/api_channel_bloc.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/hidden_menu_bloc.dart';

class HiddenMenuSheet extends StatelessWidget {
  const HiddenMenuSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => Column(
        children: [
          _Login(enabled: state.user == null),
          _Logout(enabled: state.user != null),
          BlocBuilder<ApiChannelBloc, ApiChannelState>(
            builder: (context, channelState) {
              return _ChangeChannel(
                enabled: state.user == null,
                channel: channelState.channel,
              );
            },
          ),
          _Disable(),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.title,
    required this.onTap,
    this.icon,
    this.enabled = true,
    this.requires,
  });

  final String title;
  final void Function(BuildContext) onTap;
  final Widget? icon;
  final bool enabled;
  final HiddenMenuType? requires;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HiddenMenuBloc, HiddenMenuState>(
      builder: (context, state) {
        final level = state.level;
        if (requires != null) {
          if (level == null) return const SizedBox.shrink();
          if (!level.types.contains(requires!)) return const SizedBox.shrink();
        }
        return PotPressable(
          onTap: enabled ? () => onTap(context) : null,
          child: ListTile(
            enabled: enabled,
            title: Text(title),
            leading: icon,
            contentPadding: EdgeInsets.zero,
          ),
        );
      },
    );
  }
}

class _Login extends _Button {
  _Login({super.enabled})
    : super(
        title: 'Login',
        icon: Icon(Icons.login),
        onTap: (context) {
          context.read<AuthBloc>().add(const AuthEvent.login());
        },
      );
}

class _Logout extends _Button {
  _Logout({super.enabled})
    : super(
        title: 'Logout',
        icon: Icon(Icons.logout),
        onTap: (context) {
          context.read<AuthBloc>().add(const AuthEvent.logout());
        },
      );
}

class _ChangeChannel extends _Button {
  final ApiChannel? channel;
  _ChangeChannel({super.enabled, this.channel})
    : super(
        requires: HiddenMenuType.accessAllChannels,
        title: 'Change Channel (current: ${channel?.name ?? ''})',
        icon: Icon(Icons.settings),
        onTap: (context) async {
          final newChannel = await showConfirmationDialog(
            context: context,
            title: 'Select API Channel',
            actions: ApiChannel.values
                .map(
                  (e) => AlertDialogAction(
                    key: e,
                    label: '${e.name} (${e.url}, ${e.wsUrl})',
                    isDefaultAction: e == channel,
                  ),
                )
                .toList(),
          );
          if (newChannel == null || !context.mounted) return;
          final user = AuthBloc.userOf(context);
          if (user != null) {
            showOkAlertDialog(
              context: context,
              title: 'Warning',
              message:
                  'You are already logged in. Please logout to change the API channel.',
            );
            return;
          }
          context.read<ApiChannelBloc>().add(
            ApiChannelEvent.setChannel(newChannel),
          );
          context.showToast(
            'api channel changed to ${newChannel.name}\n${newChannel.url}\n${newChannel.wsUrl}',
          );
        },
      );
}

class _Disable extends _Button {
  _Disable()
    : super(
        title: 'Disable',
        icon: Icon(Icons.disabled_by_default),
        onTap: (context) {
          context.read<HiddenMenuBloc>().add(const HiddenMenuEvent.disable());
          context.pop();
        },
      );
}
