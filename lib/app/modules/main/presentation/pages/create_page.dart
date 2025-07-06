import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';

@RoutePage()
class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: PotAppBar());
  }
}
