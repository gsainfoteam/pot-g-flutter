import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class InvitedPage extends StatelessWidget {
  const InvitedPage({super.key, @PathParam() required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(title: Text(context.t.invited.title)),
      body: Column(children: [Text(id)]),
    );
  }
}
