import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/core/data/models/pot_model.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/data/models/stop_model.dart';
import 'package:pot_g/app/router.gr.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PotButton(
        variant: PotButtonVariant.emphasized,
        onPressed: () {
          context.router.push(
            ChatRoomRoute(
              pot: PotModel(
                id: '22b59c12-a22c-441b-8efe-de75bc7e8fbf',
                current: 1,
                endsAt: DateTime.now(),
                startsAt: DateTime.now(),
                route: RouteModel(
                  id: '0',
                  from: StopModel(id: '0', name: ''),
                  to: StopModel(id: '1', name: ''),
                ),
                total: 4,
              ),
            ),
          );
        },
        child: Text('To Chat Room'),
      ),
    );
  }
}
