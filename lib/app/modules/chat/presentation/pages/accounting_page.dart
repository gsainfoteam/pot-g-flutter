import 'package:auto_route/annotations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_profile_image.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_checkbox.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_text_field.dart';
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
    return Scaffold(
      appBar: PotAppBar(title: Text(context.dutch.title)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _Amount(),
            const SizedBox(height: 28),
            _DefaultNotRegistered(),
            _BankAccount(),
            const SizedBox(height: 28),
            _SettlementTargets(pot: pot),
          ],
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
        PotTextField(),
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
          onPressed: () {},
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
            Text('우리', style: TextStyles.title4.copyWith(color: Palette.dark)),
            const SizedBox(width: 8),
            Text(
              '9999-9',
              style: TextStyles.body.copyWith(color: Palette.dark),
            ),
            Spacer(),
            PotButton(
              onPressed: () {},
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
          PotCheckbox(value: true, onChanged: (_) {}),
        ],
      ),
    );
  }
}

extension on BuildContext {
  TranslationsChatRoomAccountingDutchEn get dutch =>
      this.t.chat_room.accounting.dutch;
}
