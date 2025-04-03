import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_g_button.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('title')),
      body: Column(
        children: [
          Text('title'),
          PotGButton(
            onPressed: () {},
            variant: PotGButtonVariant.emphasized,
            child: Text('button'),
          ),
        ],
      ),
    );
  }
}
