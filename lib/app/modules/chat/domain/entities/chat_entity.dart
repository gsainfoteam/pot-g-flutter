import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/fofo_action_button_type.dart';
import 'package:pot_g/app/modules/chat/domain/enums/fofo_chat_type.dart';

sealed class Sendable {
  DateTime get createdAt;
  int get id;
}

abstract interface class ChatEntity implements Sendable {
  String get message;
  PotUserEntity get user;
}

class WaitingChatEntity implements Sendable {
  final String message;
  @override
  final DateTime createdAt;
  @override
  final int id;
  final String? error;

  static int _id = 0;

  const WaitingChatEntity._({
    required this.message,
    required this.createdAt,
    required this.id,
    this.error,
  });

  factory WaitingChatEntity.create(String message) {
    return WaitingChatEntity._(
      message: message,
      createdAt: DateTime.now(),
      id: _id++,
    );
  }

  WaitingChatEntity withError(String error) {
    return WaitingChatEntity._(
      message: message,
      createdAt: createdAt,
      id: id,
      error: error,
    );
  }
}

enum SystemMessageType { userIn, userLeave, userKicked, created, archived }

abstract interface class SystemMessageEntity implements Sendable {
  SystemMessageType get type;
  PotUserEntity? get relatedUser;
  PotUserEntity? get auxRelatedUser;
}

abstract interface class FofoChatEntity implements Sendable {
  FofoChatType? get type;
  String get content;
  List<FofoActionButtonType?> get actionButtons;
}

abstract interface class ChatEntityError implements Sendable {
  String get message;
}
