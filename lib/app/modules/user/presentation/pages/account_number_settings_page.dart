import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_bottom_sheet.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class AccountNumberSettingsPage extends StatelessWidget {
  const AccountNumberSettingsPage({super.key});

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

class _SelectBankDialog extends StatelessWidget {
  const _SelectBankDialog();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t.profile.account_number_settings.input.bank,
          style: TextStyles.title2,
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: ListView.separated(
            itemBuilder:
                (_, _) => SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Assets.icons.fofoSad.svg(),
                      ),
                      const SizedBox(width: 12),
                      Text('가은행', style: TextStyles.title3),
                    ],
                  ),
                ),
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
