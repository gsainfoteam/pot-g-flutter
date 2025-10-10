import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_page.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_toggle.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class NotificationSettingPage extends StatelessWidget with LogPageStateless {
  const NotificationSettingPage({super.key});

  @override
  String get pageName => 'notificationSetting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(
        title: Text(context.t.profile.notification_settings.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _NotificationOption(
              title: context.t.profile.notification_settings.all.title,
              description:
                  context.t.profile.notification_settings.all.description,
              value: true,
              onChanged: (value) {
                L.c(
                  'allNotification',
                  from: 'notificationSetting',
                  properties: {'value': value ? 'on' : 'off'},
                );
              },
            ),
            const SizedBox(height: 16),
            _NotificationOption(
              title: context.t.profile.notification_settings.chat.title,
              description:
                  context.t.profile.notification_settings.chat.description,
              value: true,
              onChanged: (value) {
                L.c(
                  'chattingNotification',
                  from: 'notificationSetting',
                  properties: {'value': value ? 'on' : 'off'},
                );
              },
            ),
            const SizedBox(height: 16),
            _NotificationOption(
              title: context.t.profile.notification_settings.room.title,
              description:
                  context.t.profile.notification_settings.room.description,
              value: true,
              onChanged: (value) {
                L.c(
                  'roomNotification',
                  from: 'notificationSetting',
                  properties: {'value': value ? 'on' : 'off'},
                );
              },
            ),
          ],
        ),
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
