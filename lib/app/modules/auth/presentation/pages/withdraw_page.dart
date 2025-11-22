import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/domain/enums/withdraw_consent_type.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/withdraw_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/withdraw_consent_cubit.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_checkbox.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: PotAppBar(
        title: Text(context.t.profile.account_management.withdraw),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<WithdrawConsentCubit>(
            create: (context) => sl<WithdrawConsentCubit>(),
          ),
          BlocProvider<WithdrawBloc>(create: (context) => sl<WithdrawBloc>()),
        ],
        child: BlocListener<WithdrawBloc, WithdrawState>(
          listener: (context, state) {
            state.mapOrNull(
              error: (e) => context.showToast(context.t.profile.withdraw.error),
              success: (e) =>
                  context.router.push(const MainBottomNavigationRoute()),
            );
          },
          child: BlocBuilder<WithdrawConsentCubit, WithdrawConsentState>(
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
                          context.t.profile.withdraw.description(
                            user: user.name,
                          ),
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
                                  ? () {
                                      context.read<WithdrawBloc>().add(
                                        WithdrawEvent.withdraw(),
                                      );
                                    }
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
      ),
    );
  }
}

class _ConsentList extends StatelessWidget {
  const _ConsentList();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WithdrawConsentCubit>();
    return Column(
      children: WithdrawConsentType.values.map((type) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              PotCheckbox(
                value: cubit.state.consents[type] ?? false,
                onChanged: (value) => {
                  cubit.toggleConsent(type, value ?? false),
                },
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  type.getDescription(context.t), //cubit으로 getDescription 옮기기?
                  style: TextStyles.body,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
