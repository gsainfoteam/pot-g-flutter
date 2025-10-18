import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';

class ChatErrorModel implements ChatEntityError {
  @override
  final DateTime createdAt;

  @override
  final int id;

  @override
  final String message;

  ChatErrorModel({
    required this.message,
    required this.createdAt,
    required this.id,
  });
}
