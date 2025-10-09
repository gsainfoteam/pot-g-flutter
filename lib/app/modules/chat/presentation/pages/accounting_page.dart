import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/accounting_cubit.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_info_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_profile_image.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/formatters/thousand_won_formatter.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_checkbox.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_text_field.dart';
import 'package:pot_g/app/modules/user/presentation/pages/account_number_settings_page.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class AccountingPage extends StatelessWidget {
  const AccountingPage({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<AccountingCubit>()
                    ..loadTargets(pot.usersInfo.users.where((u) => u.isInPot)),
        ),
        BlocProvider(
          create: (context) => sl<PotInfoBloc>()..add(PotInfoEvent.init(pot)),
        ),
      ],
      child: BlocListener<PotInfoBloc, PotInfoState>(
        listener: (context, state) {
          if (state is AccountingSuccess) {
            context.router.pop();
          }
          if (state.error != null) {
            context.showToast(state.error!);
          }
        },
        child: _Layout(pot: pot),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout({required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    final hasBank = AuthBloc.userOf(context, true)?.accounting.isSet == true;
    return Scaffold(
      appBar: PotAppBar(title: Text(context.dutch.title)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _Amount(),
                    const SizedBox(height: 28),
                    hasBank ? _BankAccount() : _DefaultNotRegistered(),
                    const SizedBox(height: 28),
                    _SettlementTargets(pot: pot),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: Column(
                  children: [
                    Spacer(),
                    BlocBuilder<AccountingCubit, AccountingState>(
                      builder: (context, state) {
                        return PotButton(
                          onPressed:
                              state.valid && hasBank
                                  ? () {
                                    final bloc = context.read<PotInfoBloc>();
                                    bloc.add(
                                      PotInfoEvent.accounting(
                                        state.amount!,
                                        state.targets!.toList(),
                                      ),
                                    );
                                  }
                                  : null,
                          variant: PotButtonVariant.emphasized,
                          child: Text(context.dutch.action),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.dutch.fields.amount.label,
          style: TextStyles.title4.copyWith(color: Palette.dark),
        ),
        const SizedBox(height: 8),
        PotTextField(
          onChanged: (v) {
            final amount = ThousandWonFormatter.parse(v);
            context.read<AccountingCubit>().amountChanged(amount);
          },
          inputFormatters: [
            ThousandWonFormatter(context.dutch.fields.amount.value),
          ],
          keyboardType: TextInputType.number,
          hintText: context.dutch.fields.amount.value(n: '0'),
        ),
      ],
    );
  }
}

class _DefaultNotRegistered extends StatelessWidget {
  const _DefaultNotRegistered();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.dutch.fields.account_not_registered.label,
          style: TextStyles.title4.copyWith(color: Palette.dark),
        ),
        const SizedBox(height: 8),
        Text(
          context.dutch.fields.account_not_registered.description,
          style: TextStyles.caption.copyWith(color: Palette.dark),
        ),
        const SizedBox(height: 8),
        PotButton(
          onPressed:
              () => AccountNumberSettingsPage.showAccountNumberSetting(context),
          variant: PotButtonVariant.emphasized,
          prefixIcon: Assets.icons.dollar.svg(
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              Palette.primaryLight,
              BlendMode.srcIn,
            ),
          ),
          child: Text(context.dutch.fields.account_not_registered.action),
        ),
      ],
    );
  }
}

class _BankAccount extends StatelessWidget {
  const _BankAccount();

  @override
  Widget build(BuildContext context) {
    final bank = AuthBloc.userOf(context, true)?.accounting;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.dutch.fields.account.label,
          style: TextStyles.title4.copyWith(color: Palette.dark),
        ),
        const SizedBox(height: 8),
        Text(
          context.dutch.fields.account.description,
          style: TextStyles.caption.copyWith(color: Palette.dark),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              bank?.bankShortName ?? '',
              style: TextStyles.title4.copyWith(color: Palette.dark),
            ),
            const SizedBox(width: 8),
            Text(
              bank?.account ?? '',
              style: TextStyles.body.copyWith(color: Palette.dark),
            ),
            Spacer(),
            PotButton(
              onPressed:
                  () => AccountNumberSettingsPage.showAccountNumberSetting(
                    context,
                  ),
              size: PotButtonSize.small,
              child: Text(context.dutch.fields.account.action),
            ),
          ],
        ),
      ],
    );
  }
}

class _SettlementTargets extends StatelessWidget {
  const _SettlementTargets({required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    final users = pot.usersInfo.users.where((u) => u.isInPot).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.dutch.fields.target.label,
          style: TextStyles.title4.copyWith(color: Palette.dark),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Palette.borderGrey),
          ),
          child: Column(
            children:
                users
                    .expandIndexed(
                      (index, user) => [
                        if (index != 0)
                          Container(height: 1, color: Palette.borderGrey),
                        _card(user),
                      ],
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _card(PotUserEntity user) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PotProfileImage(user: user, pot: pot),
          const SizedBox(width: 8),
          Text(
            user.name,
            style: TextStyles.description.copyWith(color: Palette.dark),
          ),
          Spacer(),
          BlocBuilder<AccountingCubit, AccountingState>(
            builder: (context, state) {
              return PotCheckbox(
                value: state.targets?.contains(user) ?? false,
                onChanged: (v) {
                  context.read<AccountingCubit>().toggleUser(user, v ?? false);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

extension on BuildContext {
  TranslationsChatRoomAccountingDutchEn get dutch =>
      this.t.chat_room.accounting.dutch;
}
