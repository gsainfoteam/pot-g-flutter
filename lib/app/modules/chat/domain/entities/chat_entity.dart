import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';

class ChatEntity {
  final String message;
  final PotUserEntity user;
  final DateTime createdAt;

  const ChatEntity({
    required this.message,
    required this.user,
    required this.createdAt,
  });

  static ChatEntity make(String message, PotUserEntity user) {
    return ChatEntity(message: message, user: user, createdAt: DateTime.now());
  }
}
