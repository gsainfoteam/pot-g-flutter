import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/withdraw_cubit.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_checkbox.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: PotAppBar(
        title: Text(context.t.profile.account_management.withdraw),
      ),
      body: BlocProvider<WithdrawCubit>(
        create: (context) {
          final cubit = sl<WithdrawCubit>();
          return cubit;
        },
        child: BlocBuilder<WithdrawCubit, WithdrawState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(color: Colors.black, width: 100, height: 100),
                      SizedBox(height: 20),
                      Text(
                        context.t.profile.account_management
                            .withdraw_description(user: user.name),
                        style: TextStyles.title2,
                      ),
                      SizedBox(height: 20),
                      _ConsentList(),
                    ],
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: PotButton(
                            onPressed: () => context.router.pop(),
                            size: PotButtonSize.large,
                            variant: PotButtonVariant.outlined,
                            child: Text(context.t.common.cancel),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: PotButton(
                            onPressed: state.allChecked
                                ? () => context.read<WithdrawCubit>().withdraw()
                                : null,
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
            );
          },
        ),
      ),
    );
  }
}

class _ConsentList extends StatelessWidget {
  const _ConsentList();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WithdrawCubit>();
    return Column(
      children: [
        Row(
          children: [
            PotCheckbox(
              value: cubit.state.accountDeletionConsent,
              onChanged: (value) => {
                cubit.toggleAccountDeletionConsent(value ?? false),
              },
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                context
                    .t
                    .profile
                    .account_management
                    .withdraw_consent
                    .account_deletion,
                style: TextStyles.body,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            PotCheckbox(
              value: cubit.state.potInfoDeletionConsent,
              onChanged: (value) => {
                cubit.togglePotInfoDeletionConsent(value ?? false),
              },
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                context
                    .t
                    .profile
                    .account_management
                    .withdraw_consent
                    .pot_info_deletion,
                style: TextStyles.body,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            PotCheckbox(
              value: cubit.state.restoreUnavailableConsent,
              onChanged: (value) => {
                cubit.toggleRestoreUnavailableConsent(value ?? false),
              },
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                context
                    .t
                    .profile
                    .account_management
                    .withdraw_consent
                    .restore_unavailable,
                style: TextStyles.body,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
