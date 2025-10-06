import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/data/models/pot_info_model.dart';
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
          context.router.push(
            ChatRoomRoute(
              pot: PotInfoModel.fromJson(
                jsonDecode(
                  '{"id":"22b59c12-a22c-441b-8efe-de75bc7e8fbf","name":"\uc9c0\uc72022b5","route":{"id":"550e8400-e29b-41d4-a716-446655440003","from":{"id":"550e8400-e29b-41d4-a716-446655440005","name":"\uc9c0\uc2a4\ud2b8"},"to":{"id":"550e8400-e29b-41d4-a716-446655440006","name":"\uc720\uc2a4\ud018\uc5b4"}},"starts_at":"2025-10-10T15:30:00.000Z","ends_at":"2025-10-10T21:30:00.000Z","status":"BEFORE_CONFIRMED","users_info":{"current":3,"total":4,"users":[{"id":"8cfca91c-3d05-4196-bac0-a6327480fdbf","name":"AAA","is_host":true,"is_in_pot":true},{"id":"18cbba89-d20e-4217-ba5c-b0ab783d98c3","name":"BBB","is_host":false,"is_in_pot":true},{"id":"ecd843b2-2ffb-4579-8eff-2b903c289729","name":"CCC","is_host":false,"is_in_pot":true}]},"accounting_info":{"requested":false,"requested_users":[]}}',
                ),
              ),
            ),
          );
        },
        child: Text('To Chat Room'),
      ),
    );
  }
}
