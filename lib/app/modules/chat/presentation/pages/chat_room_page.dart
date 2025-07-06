import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';

@RoutePage()
class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(),
      body: Column(children: [Text('Chat Room $id')]),
    );
  }
}
