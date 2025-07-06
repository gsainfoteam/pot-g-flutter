import 'package:pot_g/app/modules/auth/domain/entity/user_entity.dart';

abstract class ChatEntity {
  String get id;
  String get message;
  UserEntity get user;
  DateTime get createdAt;
}
