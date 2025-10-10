import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/fofo_action_button_type.dart';
import 'package:pot_g/app/modules/chat/domain/enums/fofo_chat_type.dart';

sealed class Sendable {
  DateTime get createdAt;
}

abstract class ChatEntity implements Sendable {
  String get message;
  PotUserEntity get user;
}

enum SystemMessageType { userIn, userLeave, userKicked }

abstract class SystemMessageEntity implements Sendable {
  SystemMessageType get type;
  PotUserEntity get relatedUser;
}

abstract class FofoChatEntity implements Sendable {
  FofoChatType? get type;
  String get content;
  List<FofoActionButtonType?> get actionButtons;
}
