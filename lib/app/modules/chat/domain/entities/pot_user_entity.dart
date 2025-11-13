import 'package:pot_g/app/modules/user/domain/entities/user_entity.dart';

abstract interface class PotUserEntity implements UserEntity {
  bool get isHost;
  bool get isInPot;
}
