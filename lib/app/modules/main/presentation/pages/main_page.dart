import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_toggle.dart';
import 'package:pot_g/app/modules/main/presentation/widgets/pot_list_item.dart';
import 'package:pot_g/gen/assets.gen.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(
        title: Text('내 정보'),
        actions: [
          PotIconButton(icon: Assets.icons.addPot.svg(), onPressed: () {}),
          PotIconButton(icon: Assets.icons.userCircle.svg(), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('title'),
            const SizedBox(height: 20),
            PotButton(
              onPressed: () {},
              variant: PotButtonVariant.emphasized,
              child: Text('button'),
            ),
            const SizedBox(height: 20),
            PotToggle(
              value: _isEnabled,
              onChanged: (value) {
                setState(() => _isEnabled = value);
              },
            ),
            PotListItem(),
          ],
        ),
      ),
    );
  }
}
