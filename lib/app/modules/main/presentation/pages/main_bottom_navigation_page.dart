import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/router.gr.dart';

@RoutePage()
class MainBottomNavigationPage extends StatelessWidget {
  const MainBottomNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: [MainRoute(), MainRoute(), MainRoute(), MainRoute()],
      builder:
          (context, child, tabController) => Scaffold(
            body: child,
            appBar: PotAppBar(),
            bottomNavigationBar: Container(),
          ),
    );
  }
}
