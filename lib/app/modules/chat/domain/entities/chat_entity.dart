import 'package:equatable/equatable.dart';
import 'package:pot_g/app/modules/auth/domain/entity/user_entity.dart';

class ChatEntity with EquatableMixin {
  final String id;
  final String message;
  final UserEntity user;
  final DateTime createdAt;

  const ChatEntity({
    required this.id,
    required this.message,
    required this.user,
    required this.createdAt,
  });

  static ChatEntity make(String message, UserEntity user) {
    return ChatEntity(
      id: '',
      message: message,
      user: user,
      createdAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, message, user, createdAt];
}
