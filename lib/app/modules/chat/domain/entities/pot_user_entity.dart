import 'package:pot_g/app/modules/user/domain/entities/user_entity.dart';

class PotUserEntity extends UserEntity {
  final bool isHost;
  final bool isInPot;

  const PotUserEntity({
    required this.isHost,
    required this.isInPot,
    required super.id,
    required super.name,
  });
}
