import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';

abstract interface class PotUsersInfoEntity {
  int get current;
  int get total;
  List<PotUserEntity> get users;
}
