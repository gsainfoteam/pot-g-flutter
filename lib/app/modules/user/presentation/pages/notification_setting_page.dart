import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_page.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_toggle.dart';
import 'package:pot_g/app/modules/user/data/models/push_setting_model.dart';
import 'package:pot_g/app/modules/user/domain/entities/push_setting_entity.dart';
import 'package:pot_g/app/modules/user/presentation/blocs/push_setting_bloc.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class NotificationSettingPage extends StatelessWidget with LogPage {
  const NotificationSettingPage({super.key});

  @override
  String get pageName => 'notificationSetting';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PushSettingBloc>()..add(const PushSettingEvent.load()),
      child: const _NotificationSettingPage(),
    );
  }
}

class _NotificationSettingPage extends StatefulWidget {
  const _NotificationSettingPage();

  @override
  State<_NotificationSettingPage> createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<_NotificationSettingPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<PushSettingBloc>().add(const PushSettingEvent.load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<PushSettingBloc>().add(
        const PushSettingEvent.checkOsPermission(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(
        title: Text(context.t.profile.notification_settings.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: BlocBuilder<PushSettingBloc, PushSettingState>(
          builder: (context, state) {
            return state.map(
              initial: (_) => const Center(child: CircularProgressIndicator()),
              loading: (_) => const Center(child: CircularProgressIndicator()),
              loaded: (s) {
                final pushSetting = s.pushSetting;
                final isOsNotificationEnabled = s.isOsNotificationEnabled;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!isOsNotificationEnabled) ...[
                      _OsNotificationWarningBanner(
                        onTap: () {
                          context.read<PushSettingBloc>().add(
                            const PushSettingEvent.openAppSettings(),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    _NotificationOption(
                      title: context.t.profile.notification_settings.all.title,
                      description: context
                          .t
                          .profile
                          .notification_settings
                          .all
                          .description,
                      value: pushSetting.allEnabled,
                      onChanged: (value) {
                        L.c(
                          'allNotification',
                          from: 'notificationSetting',
                          properties: {'value': value ? 'on' : 'off'},
                        );
                        _updatePush(
                          context,
                          pushSetting.copyWith(anyPush: value),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _NotificationOption(
                      title: context.t.profile.notification_settings.chat.title,
                      description: context
                          .t
                          .profile
                          .notification_settings
                          .chat
                          .description,
                      value: pushSetting.chatPush,
                      onChanged: (value) {
                        L.c(
                          'chattingNotification',
                          from: 'notificationSetting',
                          properties: {'value': value ? 'on' : 'off'},
                        );
                        _updatePush(
                          context,
                          pushSetting.copyWith(chatPush: value),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _NotificationOption(
                      title: context.t.profile.notification_settings.room.title,
                      description: context
                          .t
                          .profile
                          .notification_settings
                          .room
                          .description,
                      value: pushSetting.potInOutPush,
                      onChanged: (value) {
                        L.c(
                          'roomNotification',
                          from: 'notificationSetting',
                          properties: {'value': value ? 'on' : 'off'},
                        );
                        _updatePush(
                          context,
                          pushSetting.copyWith(potInOutPush: value),
                        );
                      },
                    ),
                  ],
                );
              },
              error: (e) => Center(child: Text('Error: ${e.message}')),
            );
          },
        ),
      ),
    );
  }

  void _updatePush(BuildContext context, PushSettingEntity updated) {
    context.read<PushSettingBloc>().add(PushSettingEvent.update(updated));
  }
}

class _OsNotificationWarningBanner extends StatelessWidget {
  const _OsNotificationWarningBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.t.profile.notification_settings.os_permission.warning,
                  style: TextStyles.caption.copyWith(
                    color: Colors.orange.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PotButton(
              onPressed: onTap,
              variant: PotButtonVariant.outlined,
              size: PotButtonSize.medium,
              child: Text(
                context
                    .t
                    .profile
                    .notification_settings
                    .os_permission
                    .open_settings,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationOption extends StatelessWidget {
  const _NotificationOption({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String description;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.title4),
              const SizedBox(height: 4),
              Text(description, style: TextStyles.caption),
            ],
          ),
        ),
        PotToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}

extension on PushSettingEntity {
  bool get allEnabled => chatPush && potInOutPush;

  /// when anyPush is changed, the other push settings will be changed to the same value
  /// or, anyPush will be updated along with the value of the other push settings
  PushSettingEntity copyWith({
    bool? anyPush,
    bool? chatPush,
    bool? potInOutPush,
  }) {
    if (anyPush == null) {
      return PushSettingModel(
        chatPush: chatPush ?? this.chatPush,
        potInOutPush: potInOutPush ?? this.potInOutPush,
        marketingPush: marketingPush,
      );
    }
    return PushSettingModel(
      chatPush: anyPush,
      potInOutPush: anyPush,
      marketingPush: marketingPush,
    );
  }
}
