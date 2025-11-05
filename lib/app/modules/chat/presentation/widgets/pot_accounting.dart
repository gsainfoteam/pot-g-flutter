import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/accounting_confirm_exception.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/accounting_confirm_cubit.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_accounting_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_user_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_user.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotAccounting extends StatefulWidget {
  const PotAccounting({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  State<PotAccounting> createState() => _PotAccountingState();
}

class _PotAccountingState extends State<PotAccounting> {
  bool _onlyPayer = false;

  void _showOnlyPayer() {
    setState(() {
      _onlyPayer = true;
    });
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      setState(() {
        _onlyPayer = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final me = widget.pot.getMe(context);
    final meRequesting = widget.pot.accountingInfo.requestingUser == me?.id;
    final requestedUsers = [
      ...widget.pot.accountingInfo.accountingResults.map((u) => u.userPk),
      if (!meRequesting) widget.pot.accountingInfo.requestingUser,
    ].map((id) => widget.pot.usersInfo.users.firstWhere((u) => (u.id == id)));

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<AccountingConfirmCubit>()
                ..loadInitialState(widget.pot.accountingInfo.accountingResults),
        ),
        BlocProvider(create: (context) => sl<PotAccountingBloc>()),
      ],
      child: BlocListener<PotAccountingBloc, PotAccountingState>(
        listener: (context, state) {
          state.mapOrNull(
            confirmSuccess: (_) => Scaffold.of(context).closeEndDrawer(),
            confirmError: (e) {
              final errors = context.t.chat_room.drawer.accounting.errors;
              final errorMessage = switch (e.err) {
                NotYetRequestedException() => errors.not_yet_requested,
                NotAccountingRequesterException() =>
                  errors.not_accounting_requester,
                PotNotExistException() => errors.pot_not_exist,
                PotAlreadyClosedException() => errors.pot_already_closed,
                NetworkErrorException() => errors.network_error,
                UnknownException() => errors.unknown,
              };
              context.showToast('$errorMessage (${e.errorId})');
            },
          );
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
                      widget.pot.accountingInfo.totalCost!,
                    ),
                  ),
                  TextSpan(text: ' '),
                  TextSpan(
                    text:
                        '/ ${widget.pot.accountingInfo.accountingResults.length + 1}',
                    style: TextStyles.title4.copyWith(color: Palette.grey),
                  ),
                  TextSpan(
                    text:
                        ' = ${NumberFormat.decimalPattern().format(widget.pot.accountingInfo.costPerUser!)}',
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
              PotUser(user: me!, pot: widget.pot, payStatus: PayStatus.payer),
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
                      pot: widget.pot,
                      payStatus: isDone ? PayStatus.done : PayStatus.notPaid,
                      onPay: meRequesting
                          ? (value) => context
                                .read<AccountingConfirmCubit>()
                                .toggleUser(e.id)
                          : (_) => _showOnlyPayer(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (meRequesting) ...[
              BlocBuilder<AccountingConfirmCubit, AccountingConfirmState>(
                builder: (context, state) {
                  final hasChanges = state.hasChanges(
                    widget.pot.accountingInfo.accountingResults,
                  );
                  if (!hasChanges) {
                    return _WarnBanner(
                      text: context.t.chat_room.drawer.accounting.check_to_edit,
                      color: Palette.primary,
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PotButton(
                        onPressed: () {
                          final results = context
                              .read<AccountingConfirmCubit>()
                              .getAccountingResults();
                          context.read<PotAccountingBloc>().add(
                            PotAccountingEvent.confirmAccounting(
                              widget.pot,
                              results,
                            ),
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
            ] else
              AnimatedOpacity(
                opacity: _onlyPayer ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: _WarnBanner(
                  text: context.t.chat_room.drawer.accounting.edit_payer_only,
                  color: Palette.warning,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WarnBanner extends StatelessWidget {
  const _WarnBanner({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Assets.icons.warningTriangle.svg(
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyles.caption.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
