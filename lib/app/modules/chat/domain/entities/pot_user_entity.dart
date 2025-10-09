import 'package:pot_g/app/modules/user/domain/entities/user_entity.dart';

abstract class PotUserEntity extends UserEntity {
  bool get isHost;
  bool get isInPot;
}
