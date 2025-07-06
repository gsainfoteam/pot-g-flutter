import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/auth/domain/entity/user_entity.dart';
import 'package:pot_g/app/values/palette.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.user,
    this.isFirst = false,
  });

  final String message;
  final UserEntity? user;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: user == null ? Palette.primary : Palette.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(message),
    );
  }
}
