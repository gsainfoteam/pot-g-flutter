import 'dart:math';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intersperse/intersperse.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_page.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_bottom_sheet.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_text_field.dart';
import 'package:pot_g/app/modules/user/domain/entities/bank_entity.dart';
import 'package:pot_g/app/modules/user/presentation/blocs/bank_list_bloc.dart';
import 'package:pot_g/app/modules/user/presentation/blocs/set_bank_account_bloc.dart';
import 'package:pot_g/app/modules/user/presentation/widgets/keypad.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class AccountNumberSettingsPage extends StatelessWidget with LogPage {
  const AccountNumberSettingsPage({super.key});

  static void showAccountNumberSetting(BuildContext context) {
    L.v('registerBankAlert');
    PotBottomSheet.show(context, _AlertDialog());
  }

  @override
  Widget build(BuildContext context) {
    return _Layout();
  }

  @override
  String get pageName => 'bankAccount';
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    final bank = AuthBloc.userOf(context, true)?.accounting;
    return Scaffold(
      appBar: PotAppBar(
        title: Text(context.t.profile.account_number_settings.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.t.profile.account_number_settings.default_account,
              style: TextStyles.title3,
            ),
            const SizedBox(height: 16),
            if (bank?.isSet ?? false)
              Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: bank?.bankShortName ?? '',
                            style: TextStyles.title4.copyWith(
                              color: Palette.dark,
                            ),
                          ),
                          TextSpan(text: ' '),
                          TextSpan(
                            text: bank?.account ?? '',
                            style: TextStyles.body.copyWith(
                              color: Palette.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PotButton(
                    onPressed: () {
                      L.c('changeBankAccount');
                      AccountNumberSettingsPage.showAccountNumberSetting(
                        context,
                      );
                    },
                    size: PotButtonSize.small,
                    child: Text(
                      context
                          .t
                          .profile
                          .account_number_settings
                          .has_account
                          .change,
                    ),
                  ),
                ],
              )
            else ...[
              Text(
                context
                    .t
                    .profile
                    .account_number_settings
                    .no_account
                    .description,
                style: TextStyles.description,
              ),
              const SizedBox(height: 16),
              PotButton(
                onPressed: () {
                  L.c('registerBankAccount');
                  AccountNumberSettingsPage.showAccountNumberSetting(context);
                },
                variant: PotButtonVariant.emphasized,
                prefixIcon: Assets.icons.dollar.svg(
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    Palette.primaryLight,
                    BlendMode.srcIn,
                  ),
                ),
                child: Text(
                  context.t.profile.account_number_settings.no_account.button,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AlertDialog extends StatelessWidget {
  const _AlertDialog();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t.profile.account_number_settings.alert.title,
          style: TextStyles.title2,
        ),
        const SizedBox(height: 12),
        Text(
          context.t.profile.account_number_settings.alert.description,
          style: TextStyles.body,
        ),
        const SizedBox(height: 32),
        FittedBox(child: Assets.images.cautionFofo.svg()),
        const SizedBox(height: 32),
        PotButton(
          onPressed: () {
            L.c('registerBankContinue', from: 'registerBankAlert');
            context.router.pop();
            L.v('selectBank', from: 'registerBankAlert');
            PotBottomSheet.show(context, _SelectBankDialog());
          },
          variant: PotButtonVariant.outlined,
          child: Text(context.t.profile.account_number_settings.alert.next),
        ),
      ],
    );
  }
}

class _SelectBankDialog extends StatefulWidget {
  const _SelectBankDialog();

  @override
  State<_SelectBankDialog> createState() => _SelectBankDialogState();
}

class _SelectBankDialogState extends State<_SelectBankDialog> {
  BankEntity? selectedBank;
  final _controller = ScrollController();
  double _pixels = 0;
  String _search = '';

  @override
  initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _pixels = _controller.position.pixels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BankListBloc>()..add(BankListEvent.load()),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: selectedBank != null
            ? _BankNumber(
                selectedBank: selectedBank!,
                onSelectBank: () => setState(() => selectedBank = null),
              )
            : _buildBankList(),
      ),
    );
  }

  Widget _buildBankList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t.profile.account_number_settings.select_bank.bank,
          style: TextStyles.title2,
        ),
        const SizedBox(height: 20),
        PotTextField(
          onChanged: (value) => setState(() => _search = value),
          filled: true,
          suffixIcon: Assets.icons.search.svg(
            colorFilter: ColorFilter.mode(Palette.textGrey, BlendMode.srcIn),
          ),
          hintText:
              context.t.profile.account_number_settings.select_bank.placeholder,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: lerpDouble(300, 500, clampDouble(_pixels / 100, 0, 1)),
          child: BlocBuilder<BankListBloc, BankListState>(
            builder: (context, state) => SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: [
                  ...state.banks
                      .where((b) => !b.isSecurities)
                      .where(
                        (b) =>
                            _search.isEmpty ||
                            b.name.toLowerCase().contains(
                              _search.toLowerCase(),
                            ),
                      )
                      .toList()
                      .chunked(3)
                      .map(_buildBankRow)
                      .intersperse(const SizedBox(height: 20)),
                  Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    color: Palette.borderGrey,
                  ),
                  ...state.banks
                      .where((b) => b.isSecurities)
                      .where(
                        (b) =>
                            _search.isEmpty ||
                            b.name.toLowerCase().contains(
                              _search.toLowerCase(),
                            ),
                      )
                      .toList()
                      .chunked(3)
                      .map(_buildBankRow)
                      .intersperse(const SizedBox(height: 20)),
                  const SizedBox(height: 20),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankRow(List<BankEntity> banks) {
    return Row(
      children: [...banks, null, null]
          .sublist(0, 3)
          .map<Widget>(
            (b) => Expanded(
              child: b == null
                  ? const SizedBox()
                  : PotPressable(
                      onTap: () {
                        L.c('selectBank', from: 'selectBank');
                        setState(() => selectedBank = b);
                      },
                      child: _Bank(bank: b),
                    ),
            ),
          )
          .intersperse(const SizedBox(width: 8))
          .toList(),
    );
  }
}

class _Bank extends StatelessWidget {
  const _Bank({required this.bank});

  final BankEntity bank;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            border: Border.all(color: Palette.borderGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(bank.logoUrl),
        ),
        const SizedBox(height: 4),
        Text(bank.name, style: TextStyles.description),
      ],
    );
  }
}

class _BankNumber extends StatefulWidget {
  const _BankNumber({required this.selectedBank, required this.onSelectBank});

  final BankEntity selectedBank;
  final VoidCallback onSelectBank;

  @override
  State<_BankNumber> createState() => _BankNumberState();
}

class _BankNumberState extends State<_BankNumber> {
  final controller = TextEditingController();
  final bloc = sl<SetBankAccountBloc>();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocListener<SetBankAccountBloc, SetBankAccountState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.read<AuthBloc>().add(AuthEvent.update());
            context.router.pop();
          }
          if (state.errorMessage != null) {
            context.showToast(state.errorMessage!);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: Palette.borderGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(widget.selectedBank.logoUrl),
                ),
                const SizedBox(width: 8),
                Text(widget.selectedBank.name, style: TextStyles.title3),
                const SizedBox(width: 12),
                PotPressable(
                  onTap: widget.onSelectBank,
                  child: Assets.icons.navArrowDown.svg(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PotTextField(
              maxLength: 20,
              autoFocus: true,
              filled: true,
              controller: controller,
              keyboardType: TextInputType.none,
              hintText: context
                  .t
                  .profile
                  .account_number_settings
                  .bank_number
                  .placeholder,
            ),
            const SizedBox(height: 20),
            Keypad(controller: controller),
            const SizedBox(height: 20),
            PotButton(
              onPressed:
                  controller.text.length >= 5 && controller.text.length <= 20
                  ? () {
                      L.c('registerBankAccount', from: 'bankAccountNumber');
                      bloc.add(
                        SetBankAccountEvent.set(
                          widget.selectedBank,
                          controller.text,
                        ),
                      );
                    }
                  : null,
              variant: PotButtonVariant.emphasized,
              child: Text(
                context.t.profile.account_number_settings.bank_number.register,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on List<BankEntity> {
  List<List<BankEntity>> chunked(int size) {
    final result = <List<BankEntity>>[];
    for (var i = 0; i < length; i += size) {
      result.add(sublist(i, min(i + size, length)));
    }
    return result;
  }
}
