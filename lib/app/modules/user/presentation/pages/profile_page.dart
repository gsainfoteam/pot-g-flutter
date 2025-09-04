import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/domain/entity/user_entity.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_toggle.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: SingleChildScrollView(child: _Inner(user: user)),
      ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
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
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      context.t.profile.basic_info.email,
                      style: TextStyles.title4,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: user.email.split('@')[0],
                          style: TextStyles.body,
                        ),
                        TextSpan(text: '@'),
                        TextSpan(text: user.email.split('@')[1]),
                      ],
                      style: TextStyles.caption,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                context.t.profile.basic_info.description,
                style: TextStyles.caption.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        _Section(
          title: context.t.profile.settings.title,
          child: Container(
            decoration: BoxDecoration(
              color: Palette.lightGrey,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MenuButton(
                  title: context.t.profile.account_number_settings.title,
                  onTap: () {},
                ),
                Container(height: 1, color: Palette.borderGrey),
                _MenuButton(
                  title: context.t.profile.notification_settings.title,
                  onTap: () {},
                ),
                Container(height: 1, color: Palette.borderGrey),
                _MenuButton(
                  title: context.t.profile.account_management.title,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PotPressable(
      onTap: onTap,
      hitTestBehavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyles.title4),
            Assets.icons.navArrowRight.svg(
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(Palette.dark, BlendMode.srcIn),
            ),
          ],
        ),
      ),
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
        SizedBox(height: 6),
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
