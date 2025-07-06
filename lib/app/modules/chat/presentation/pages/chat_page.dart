import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
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
          context.router.push(ChatRoomRoute(id: '1'));
        },
        child: Text('To Chat Room'),
      ),
    );
  }
}
