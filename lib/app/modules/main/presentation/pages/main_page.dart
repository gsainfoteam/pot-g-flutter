import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_g_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_g_toggle.dart';

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
      appBar: AppBar(title: Text('title')),
      body: Column(
        children: [
          Text('title'),
          const SizedBox(height: 20),
          PotGButton(
            onPressed: () {},
            variant: PotGButtonVariant.emphasized,
            child: Text('button'),
          ),
          const SizedBox(height: 20),
          PotGToggle(
            value: _isEnabled,
            onChanged: (value) {
              setState(() => _isEnabled = value);
            },
          ),
        ],
      ),
    );
  }
}
