import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_page.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class AccountManagementPage extends StatelessWidget with LogPageStateless {
  const AccountManagementPage({super.key});

  @override
  String get pageName => 'accountSetting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(
        title: Text(context.t.profile.account_management.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Button(
              title: context.t.profile.account_management.logout,
              onTap: () async {
                L.c('logout');
                final result = await showOkCancelAlertDialog(
                  title:
                      context
                          .t
                          .profile
                          .account_management
                          .logout_dialog
                          .description,
                  context: context,
                );
                if (!context.mounted) return;
                if (result == OkCancelResult.ok) {
                  context.read<AuthBloc>().add(const AuthEvent.logout());
                  context.router.replaceAll([ListRoute()]);
                }
              },
            ),
            const SizedBox(height: 16),
            _Button(
              title: context.t.profile.account_management.withdraw,
              onTap: () {
                L.c('withdraw');
                launchUrl(Uri.parse('https://idp.gistory.me'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PotPressable(
      hitTestBehavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyles.title4),
            Assets.icons.navArrowRight.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
