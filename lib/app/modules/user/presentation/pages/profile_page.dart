import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/domain/entity/user_entity.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_toggle.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = switch (context.watch<AuthBloc>().state) {
      Authenticated(:final user) => user,
      _ => null,
    };
    if (user == null) {
      return Center(
        child: PotButton(
          variant: PotButtonVariant.emphasized,
          child: Text('login'),
          onPressed:
              () => context.read<AuthBloc>().add(const AuthEvent.login()),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: SingleChildScrollView(child: _Inner(user: user)),
    );
  }
}

class _Inner extends StatelessWidget {
  const _Inner({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Section(
          title: context.t.profile.basic_info.title,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      context.t.profile.basic_info.name,
                      style: TextStyles.title4,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(user.name, style: TextStyles.body),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      context.t.profile.basic_info.email,
                      style: TextStyles.title4,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(user.email, style: TextStyles.body),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        _Section(
          title: context.t.profile.notification_settings.title,
          child: Column(
            children: [
              _NotificationOption(
                title: context.t.profile.notification_settings.all.title,
                description:
                    context.t.profile.notification_settings.all.description,
                value: true,
                onChanged: (value) {},
              ),
              SizedBox(height: 8),
              _NotificationOption(
                title: context.t.profile.notification_settings.chat.title,
                description:
                    context.t.profile.notification_settings.chat.description,
                value: true,
                onChanged: (value) {},
              ),
              SizedBox(height: 8),
              _NotificationOption(
                title: context.t.profile.notification_settings.event.title,
                description:
                    context.t.profile.notification_settings.event.description,
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        _Section(
          title: context.t.profile.account_number_settings.title,
          child: Column(
            children: [
              Text(
                context.t.profile.account_number_settings.description,
                style: TextStyles.description,
              ),
              SizedBox(height: 12),
              PotButton(
                onPressed: () {},
                variant: PotButtonVariant.emphasized,
                child: Row(
                  children: [
                    Assets.icons.dollar.svg(),
                    SizedBox(width: 8),
                    Text(context.t.profile.account_number_settings.button),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        _Section(
          title: context.t.profile.account_management.title,
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.read<AuthBloc>().add(AuthEvent.logout()),
                child: SizedBox(
                  height: 44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.t.profile.account_management.logout,
                        style: TextStyles.title4,
                      ),
                      Assets.icons.navArrowRight.svg(),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => launchUrl(Uri.parse('https://idp.gistory.me')),
                child: SizedBox(
                  height: 44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.t.profile.account_management.withdraw,
                        style: TextStyles.title4,
                      ),
                      Assets.icons.navArrowRight.svg(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: TextStyles.title2),
        SizedBox(height: 12),
        child,
      ],
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyles.title4),
            const SizedBox(height: 4),
            Text(description, style: TextStyles.caption),
          ],
        ),
        PotToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}
