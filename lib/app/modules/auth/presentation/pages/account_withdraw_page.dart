import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_checkbox.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class AccountWithdrawPage extends StatelessWidget {
  const AccountWithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: PotAppBar(
        title: Text(context.t.profile.account_management.withdraw),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(color: Colors.black, width: 100, height: 100),
                  SizedBox(height: 20),
                  Text(
                    context.t.profile.account_management.withdraw_description(
                      user: user.name,
                    ),
                    style: TextStyles.title2,
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      _WithdrawConsent(
                        description: context
                            .t
                            .profile
                            .account_management
                            .withdraw_consent
                            .account_deletion,
                      ),
                      SizedBox(height: 12),
                      _WithdrawConsent(
                        description: context
                            .t
                            .profile
                            .account_management
                            .withdraw_consent
                            .pot_info_deletion,
                      ),
                      SizedBox(height: 12),
                      _WithdrawConsent(
                        description: context
                            .t
                            .profile
                            .account_management
                            .withdraw_consent
                            .restore_anavailable,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: PotButton(
                      size: PotButtonSize.large,
                      variant: PotButtonVariant.outlined,
                      child: Text(context.t.common.cancel),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: PotButton(
                      size: PotButtonSize.large,
                      variant: PotButtonVariant.emphasized,
                      child: Text(
                        context.t.profile.account_management.withdraw,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WithdrawConsent extends StatelessWidget {
  const _WithdrawConsent({super.key, required this.description});
  final String description;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PotCheckbox(value: false, onChanged: (value) => {}),
        SizedBox(width: 8),
        Expanded(child: Text(description, style: TextStyles.body)),
      ],
    );
  }
}
