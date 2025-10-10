import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/accounting_confirm_cubit.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_info_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_user_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_user.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotAccounting extends StatelessWidget {
  const PotAccounting({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    final me = pot.getMe(context);
    final meRequesting = pot.accountingInfo.requestingUser == me?.id;
    final requestedUsers = [
      ...pot.accountingInfo.accountingResults.map((u) => u.userPk),
      if (!meRequesting) pot.accountingInfo.requestingUser,
    ].map((id) => pot.usersInfo.users.firstWhere((u) => (u.id == id)));

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<AccountingConfirmCubit>()
                    ..loadInitialState(pot.accountingInfo.accountingResults),
        ),
        BlocProvider(
          create: (context) => sl<PotInfoBloc>()..add(PotInfoEvent.init(pot)),
        ),
      ],
      child: BlocListener<PotInfoBloc, PotInfoState>(
        listener: (context, state) {
          if (state is AccountingConfirmSuccess) {
            Scaffold.of(context).closeEndDrawer();
          }
          if (state.error != null) {
            context.showToast(state.error!);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.t.chat_room.drawer.accounting.amount,
              style: TextStyles.caption.copyWith(color: Palette.textGrey),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: NumberFormat.decimalPattern().format(
                      pot.accountingInfo.totalCost!,
                    ),
                  ),
                  TextSpan(text: ' '),
                  TextSpan(
                    text:
                        '/ ${pot.accountingInfo.accountingResults.length + 1}',
                    style: TextStyles.title4.copyWith(color: Palette.grey),
                  ),
                  TextSpan(
                    text:
                        ' = ${NumberFormat.decimalPattern().format(pot.accountingInfo.costPerUser!)}',
                  ),
                ],
              ),
              style: TextStyles.title2.copyWith(color: Palette.dark),
            ),
            const SizedBox(height: 20),
            if (meRequesting) ...[
              Text(
                context.t.chat_room.drawer.members.my,
                style: TextStyles.caption.copyWith(color: Palette.textGrey),
              ),
              const SizedBox(height: 8),
              PotUser(user: me!, pot: pot, payStatus: PayStatus.payer),
              const SizedBox(height: 20),
            ],
            Text(
              context.t.chat_room.drawer.accounting.status_title,
              style: TextStyles.caption.copyWith(color: Palette.textGrey),
            ),
            const SizedBox(height: 8),
            ...requestedUsers.expandIndexed(
              (index, e) => [
                if (index != 0) const SizedBox(height: 8),
                BlocBuilder<AccountingConfirmCubit, AccountingConfirmState>(
                  builder: (context, state) {
                    final isDone = state.userStates[e.id] ?? false;
                    return PotUser(
                      user: e,
                      pot: pot,
                      payStatus: isDone ? PayStatus.done : PayStatus.notPaid,
                      onPay:
                          (value) => context
                              .read<AccountingConfirmCubit>()
                              .toggleUser(e.id),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<AccountingConfirmCubit, AccountingConfirmState>(
              builder: (context, state) {
                final hasChanges = state.hasChanges(
                  pot.accountingInfo.accountingResults,
                );
                if (!hasChanges) return const SizedBox.shrink();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PotButton(
                      onPressed: () {
                        final results =
                            context
                                .read<AccountingConfirmCubit>()
                                .getAccountingResults();
                        context.read<PotInfoBloc>().add(
                          PotInfoEvent.confirmAccounting(results),
                        );
                      },
                      variant: PotButtonVariant.emphasized,
                      size: PotButtonSize.medium,
                      child: Text(context.t.chat_room.drawer.accounting.save),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
