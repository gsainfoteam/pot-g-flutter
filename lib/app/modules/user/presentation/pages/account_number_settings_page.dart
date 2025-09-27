import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_bottom_sheet.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_text_field.dart';
import 'package:pot_g/app/modules/user/domain/entities/bank_entity.dart';
import 'package:pot_g/app/modules/user/presentation/blocs/bank_list_bloc.dart';
import 'package:pot_g/app/modules/user/presentation/widgets/keypad.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class AccountNumberSettingsPage extends StatelessWidget {
  const AccountNumberSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Layout();
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
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
            Text(
              context.t.profile.account_number_settings.no_account.description,
              style: TextStyles.description,
            ),
            const SizedBox(height: 16),
            PotButton(
              onPressed: () => PotBottomSheet.show(context, _AlertDialog()),
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
            context.router.pop();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BankListBloc>()..add(BankListEvent.load()),
      child:
          selectedBank != null
              ? _BankNumber(selectedBank: selectedBank)
              : _buildBankList(),
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
          suffixIcon: Assets.icons.search.svg(
            colorFilter: ColorFilter.mode(Palette.textGrey, BlendMode.srcIn),
          ),
          hintText:
              context.t.profile.account_number_settings.select_bank.placeholder,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: BlocBuilder<BankListBloc, BankListState>(
            builder:
                (context, state) => ListView.separated(
                  itemBuilder:
                      (_, index) => PotPressable(
                        hitTestBehavior: HitTestBehavior.opaque,
                        onTap:
                            () => setState(
                              () => selectedBank = state.banks[index],
                            ),
                        child: SizedBox(
                          height: 48,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Image.network(
                                  'https://placeholder.co/150',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                state.banks[index].name,
                                style: TextStyles.title3,
                              ),
                            ],
                          ),
                        ),
                      ),
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemCount: state.banks.length,
                ),
          ),
        ),
      ],
    );
  }
}

class _BankNumber extends StatefulWidget {
  const _BankNumber({required this.selectedBank});

  final BankEntity? selectedBank;

  @override
  State<_BankNumber> createState() => _BankNumberState();
}

class _BankNumberState extends State<_BankNumber> {
  final controller = TextEditingController();

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.selectedBank!.name, style: TextStyles.title2),
        const SizedBox(height: 20),
        PotTextField(
          controller: controller,
          readOnly: true,
          hintText:
              context.t.profile.account_number_settings.bank_number.placeholder,
        ),
        const SizedBox(height: 20),
        Keypad(controller: controller),
        const SizedBox(height: 20),
        PotButton(
          onPressed:
              controller.text.length > 5 ? () => context.router.pop() : null,
          variant: PotButtonVariant.emphasized,
          child: Text(
            context.t.profile.account_number_settings.bank_number.register,
          ),
        ),
      ],
    );
  }
}
