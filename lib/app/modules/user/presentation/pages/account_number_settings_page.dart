import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
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
      body: const Placeholder(),
    );
  }
}
