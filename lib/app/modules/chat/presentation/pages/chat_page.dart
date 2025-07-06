import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_list_item.dart';
import 'package:pot_g/app/modules/core/data/models/pot_model.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/data/models/stop_model.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyStop = StopModel(id: '', name: '안지송송');
    final dummyStart = StopModel(id: '', name: '지송');
    final dummyRoute = RouteModel(id: '', from: dummyStart, to: dummyStop);
    final dummyPot = PotModel(
      current: 2,
      total: 4,
      startsAt: DateTime(2025, 7, 6, 10, 0),
      endsAt: DateTime(2025, 7, 6, 12, 30),
      id: '',
      route: dummyRoute,
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ChatListItem(pot: dummyPot),
        ),
      ),
    );
  }
}
